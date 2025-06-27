import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/detection_service.dart';
import '../services/sms_service.dart';
import '../services/email_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DetectionScreen extends StatefulWidget {
  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  DetectionService? _detectionService;
  SmsService? _smsService;
  EmailService? _emailService;

  List<dynamic> _detections = [];
  bool _alertActive = false;
  String _alertMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeCamera();
  }

  void _initializeServices() {
    _detectionService = DetectionService(serverUrl: 'http://your-server-url/detect');
    _smsService = SmsService(
      accountSid: 'your_account_sid',
      authToken: 'your_auth_token',
      twilioNumber: 'your_twilio_number',
    );
    _emailService = EmailService();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
      _startImageStream();
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_alertActive) return; // Skip processing if alert active

      try {
        // Convert CameraImage to JPEG bytes
        final bytes = await convertYUV420toJPEG(image);
        // Send to detection service
        final detections = await _detectionService!.detectWeapons(bytes);

        if (detections.isNotEmpty) {
          _handleDetection(detections, bytes);
        }
      } catch (e) {
        print('Error en detección: $e');
      }
    });
  }

  Future<Uint8List> convertYUV420toJPEG(CameraImage image) async {
    // Placeholder: Implement conversion or use a package
    // For now, return empty bytes to avoid errors
    return Uint8List(0);
  }

  Future<void> _handleDetection(List<dynamic> detections, Uint8List imageBytes) async {
    setState(() {
      _alertActive = true;
      _alertMessage = '¡Arma detectada!';
      _detections = detections;
    });

    // Save image to temporary file
    final tempDir = await getTemporaryDirectory();
    final imagePath = '${tempDir.path}/alert_image.jpg';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);

    // Send SMS
    try {
      await _smsService!.sendSms('emergency_phone_number', 'Alerta: Arma detectada!');
    } catch (e) {
      print('Error enviando SMS: $e');
    }

    // Send Email
    try {
      await _emailService!.sendEmail(
        toEmail: 'emergency_email@example.com',
        subject: 'Alerta de detección de arma',
        body: 'Se ha detectado un arma. Imagen adjunta.',
        attachmentPaths: [imagePath],
      );
    } catch (e) {
      print('Error enviando correo: $e');
    }

    // After alert, reset after delay
    await Future.delayed(Duration(seconds: 10));
    if (mounted) {
      setState(() {
        _alertActive = false;
        _alertMessage = '';
        _detections = [];
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detección en Tiempo Real'),
        centerTitle: true,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                if (_alertActive)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.redAccent.withOpacity(0.8),
                      child: Text(
                        _alertMessage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // TODO: Add bounding boxes overlay here using _detections
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
