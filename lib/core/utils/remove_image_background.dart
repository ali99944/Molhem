import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


Future<File> removeBackground(File imageFile) async {
  var url = Uri.parse('https://api.remove.bg/v1.0/removebg');
  var request = http.MultipartRequest('POST', url);
  request.headers['X-Api-Key'] = 'MFjBHaA1SuMxBJDoojahVybf'; // Replace with your Remove.bg API key
  request.files.add(await http.MultipartFile.fromPath('image_file', imageFile.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    // Save the processed image to a temporary file
    var tempDir = await getTemporaryDirectory();
    var tempPath = path.join(tempDir.path, 'processed_image.png');
    var processedImageFile = File(tempPath);
    await processedImageFile.writeAsBytes(await response.stream.toBytes());

    return processedImageFile;
  } else {
    throw Exception('Failed to remove background: ${response.reasonPhrase}');
  }
}


