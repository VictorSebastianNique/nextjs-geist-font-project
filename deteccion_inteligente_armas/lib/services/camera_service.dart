import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  Future<void> initializeCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();
  }

  CameraController? get controller => _controller;

  void dispose() {
    _controller?.dispose();
  }
}
