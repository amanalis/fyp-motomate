import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanFeature extends StatefulWidget {
  const ScanFeature({Key? key}) : super(key: key);

  @override
  _ScanFeatureState createState() => _ScanFeatureState();
}

class _ScanFeatureState extends State<ScanFeature> {
  File? _file;
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
      print('Image saved to: ${_file!.path}');
    }
  }

  Future<void> _scanImage() async {
    if (_file != null) {
      try {
        final response = await _sendImage();

        // Check for detections in the response
        if (response.data != null && response.data.isNotEmpty) {
          final List detections = response.data;

          if (detections.isNotEmpty) {
            // At least one detection found
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('70 CC Engine Detected'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // No detections
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Not Detected! Please scan again'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          // No response data or empty list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No detections found!, Please try to scan again'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } on DioException catch (e) {
        print('Dio error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error occurred: ${e.message}'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Handle other exceptions
        print('Error during detection: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred during detection'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image first'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<Response> _sendImage() async {
    final uri = 'http://192.168.0.110:5000/detect/image'; // Replace with your Flask server URL
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_file!.path, filename: 'image.jpg'),
      });

      final response = await _dio.post(uri, data: formData);
      return response;
    } catch (e) {
      print('Dio error: $e');
      throw Exception('Failed to send image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Feature')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _file == null
                ? Text('No image selected.')
                : Image.file(_file!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Select Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Capture Image with Camera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanImage,
              child: Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
