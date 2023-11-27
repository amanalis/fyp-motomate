import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void Post_Dialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();

  return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _textEditingController =
            TextEditingController();

        return StatefulBuilder(builder: (context, setState) {
          // File? _image;
          // Future<void> _getImage() async {
          //   try {
          //     final imagePicker = ImagePicker();
          //     final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
          //
          //     setState(() {
          //       if (pickedFile != null) {
          //         _image = File(pickedFile.path as List<Object>);
          //       } else {
          //         print('No image selected.');
          //       }
          //     });
          //   } catch (e) {
          //     print('Error picking image: $e');
          //   }
          // }

          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(

              key: _formKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xff2A303E),
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
                          child: Image.asset("images/close_icon.png",color: Colors.white,))),
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
                          controller: _textEditingController,
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
                          // controller: _textEditingController,
                          validator: (value) {
                            return value!.isNotEmpty ? null : "Invaild Feild";
                          },
                          decoration: InputDecoration(
                              hintText: "Please Enter Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        // Container(
                        //   child: GestureDetector(
                        //     onTap: _getImage,
                        //     child: Container(
                        //       width: 200,
                        //       height: 200,
                        //       color: Colors.grey,
                        //       child: _image == null
                        //           ? Center(
                        //         child: Icon(
                        //           Icons.add,
                        //           size: 50,
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //           : Image.file(
                        //         _image as File,
                        //         width: 200,
                        //         height: 200,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                onPressed: () {},
                                child: Text("Cancel")),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Color(0xff2A303E),
                                    backgroundColor: Color(0xff5BEC84),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8)),
                                onPressed: () {},
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
