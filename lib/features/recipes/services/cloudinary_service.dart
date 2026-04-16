import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';

class CloudinaryService {
  const CloudinaryService();

  Future<String> uploadImage(XFile image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamed = await request.send();
    final body = jsonDecode(await streamed.stream.bytesToString());

    if (streamed.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${body['error']?['message']}');
    }
    return body['secure_url'] as String;
  }

  /// Uploads raw image bytes to Cloudinary and returns the secure URL.
  Future<String> uploadImageBytes(Uint8List bytes, String mimeType) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'recipe.jpg',
        ),
      );

    final streamed = await request.send();
    final body = jsonDecode(await streamed.stream.bytesToString());

    if (streamed.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${body['error']?['message']}');
    }
    return body['secure_url'] as String;
  }
}
