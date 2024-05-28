import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

pickImage(ImageSource source)async{
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if(file != null){
    return await file.readAsBytes();
  }
  print("No Image Selected");
}

class ImageStoreMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> imageToStorage(Uint8List file) async{
    String id = const Uuid().v1();
    Reference ref = _storage.ref().child('scan_images').child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}