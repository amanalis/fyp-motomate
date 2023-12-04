import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/flutter_toast.dart';

import '../utils/shared_prefs.dart';

void Post_Dialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();

  return await showDialog(
      context: context,
      builder: (context) {

        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        String imageUrl="";
        List<String> images = [];

        return StatefulBuilder(builder: (context, setState) {

          File? _image;
          Future<void> _getImage() async {
            ImagePicker imagePiker = ImagePicker();
            XFile? file= await imagePiker.pickImage(source: ImageSource.gallery);
            print('${file?.path}');

            if(file == null) return;
            String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('post_images');

            Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
            try {
              await referenceImageToUpload.putFile(File(file.path));

              imageUrl= await referenceImageToUpload.getDownloadURL();
              images.add(imageUrl);

              setState(() {
              //   if (pickedFile != null) {
              //     _image = File(pickedFile.path);
              //   } else {
              //     print('No image selected.');
              //   }
                imageUrl = imageUrl;
               });
            } catch (e) {
              print('Error picking image: $e');
            }
          }

          return AlertDialog(
            backgroundColor: Colors.deepOrangeAccent.withOpacity(0.6),
            content: Container(
              key: _formKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.transparent
                // Color(0xff2A303E),
              ),
              child: Stack(
                children: [
                  Positioned(
                      width: 28,
                      height: 28,
                      top: 0,
                      right: 0,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            backgroundColor: Color(0xffEC5B5B),
                            shape: CircleBorder(),
                          ),
                          child: Image.asset(
                            "images/close_icon.png",
                            color: Colors.white,
                          ))),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "images/motomate.png",
                          width: 75,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (value) {
                            return value!.isNotEmpty ? null : "Invalid Field";
                          },
                          decoration: InputDecoration(
                              hintText: "Please Enter Your Title",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          validator: (value) {
                            return value!.isNotEmpty ? null : "Invaild Feild";
                          },
                          decoration: InputDecoration(
                              hintText: "Please Enter Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                              ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: _getImage,
                            child: Container(
                              width: 200,
                              height: 150,
                              color: Colors.grey,
                              child: _image == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                          Text("Add Images."),
                                        ],
                                      ),
                                    )
                                  : Image.file(
                                      _image!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 32,
                                    ),
                                    foregroundColor: Color(0xffEC5B5B),
                                    side: BorderSide(color: Color(0xffEC5B5B))),
                                onPressed: () {
                                  titleController.clear();
                                  descriptionController.clear();
                                  images.clear();
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Color(0xff2A303E),
                                    backgroundColor: Color(0xff5BEC84),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8)),
                                onPressed: () async {
                                  String Id = (await SharedPrefs().getData('id'))!;
                                  int count = await PostModel().getPostCount();
                                  await PostModel().addPost(postID: count, userID: Id, title: titleController.text, description: descriptionController.text, imageURL: images);
                                  displayToastMessage("Posted", context);
                                  Navigator.pop(context);
                                },
                                child: Text("Post"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
