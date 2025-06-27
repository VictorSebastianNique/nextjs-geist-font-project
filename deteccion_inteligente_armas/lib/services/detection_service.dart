import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class DetectionService {
  final String serverUrl;

  DetectionService({required this.serverUrl});

  Future<List<dynamic>> detectWeapons(Uint8List frameBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(http.MultipartFile.fromBytes('frame', frameBytes, filename: 'frame.jpg'));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        // Expected to return list of detections with bounding boxes and classes
        return jsonResponse['detections'] ?? [];
      } else {
        throw Exception('Error en la detección: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la conexión con el servidor: $e');
    }
  }
}
