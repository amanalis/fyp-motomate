import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/screens/profile.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/flutter_toast.dart';

import '../utils/shared_prefs.dart';

Future Post_Dialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        String imageUrl = "";
        List<String> images = [];

        return StatefulBuilder(builder: (context, setState) {
          File? _image;
          bool Imagepicked = false;
          Future<void> _getImage() async {
            final image =
                await ImagePicker().pickImage(source: ImageSource.gallery);

            // XFile? file= await imagePiker.pickImage(source: ImageSource.gallery);
            // print('${file?.path}');

            if (image == null) return;
            String uniqueFileName =
                DateTime.now().microsecondsSinceEpoch.toString();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('post_images');

            Reference referenceImageToUpload =
                referenceDirImages.child(uniqueFileName);
            try {
              await referenceImageToUpload.putFile(File(image.path));

              String tempimageUrl =
                  await referenceImageToUpload.getDownloadURL();
              images.add(tempimageUrl);
              print(images);
              final tempimage = File(image.path);
              setState(() {
                _image = tempimage;
                Imagepicked = true;
                //   if (pickedFile != null) {
                //     _image = File(pickedFile.path);
                //   } else {
                //     print('No image selected.');
                //   }
                imageUrl = tempimageUrl;
              });
            } catch (e) {
              print('Error picking image: $e');
            }
          }

          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.8),
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
                            padding: const EdgeInsets.all(8),
                            backgroundColor: const Color(0xffEC5B5B),
                            shape: const CircleBorder(),
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
                        const SizedBox(
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
                        const SizedBox(
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
                        const SizedBox(
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
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 32,
                                    ),
                                    foregroundColor: const Color(0xffEC5B5B),
                                    side: const BorderSide(
                                        color: Color(0xffEC5B5B))),
                                onPressed: () {
                                  titleController.clear();
                                  descriptionController.clear();
                                  images.clear();
                                },
                                child: const Text("Cancel")),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xff2A303E),
                                    backgroundColor: const Color(0xff5BEC84),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 8)),
                                onPressed: () async {
                                  print(images);
                                  String Id =
                                      (await SharedPrefs().getData('id'))!;
                                  int count = await PostModel().getPostCount();
                                  DateTime now = DateTime.now();
                                  String date = DateFormat("yyyy/MM/dd HH:mm").format(now);
                                  await PostModel().addPost(
                                      postID: count,
                                      userID: Id,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      imageURL: images, date: date );
                                  displayToastMessage("Posted", context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Post"))
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

class PostDailog extends StatefulWidget {
  final String? title;
  final String? Description;
  final List? Image;
  final bool isEdit;
  final String? post_id;

  const PostDailog(
      {super.key,
      this.title,
      this.Description,
      this.Image,
      required this.isEdit,
      this.post_id});

  @override
  State<PostDailog> createState() => _PostDailogState();
}

class _PostDailogState extends State<PostDailog> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  List? pickedImage;
  List images = [];
  List Db_images=[];

  void getdata() {
    if (widget.isEdit == true) {
      setState(() {
        titlecontroller.text = widget.title!;
        descriptioncontroller.text = widget.Description!;
        images = widget.Image!;
      });
      print(images);
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  void selectImages() async {
    final List selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      images.addAll(selectedImages);
    }
    setState(() {});
  }

  void  pickImage() async {

    try {
      final List selectedimage = await ImagePicker().pickMultiImage();

      if (selectedimage.isNotEmpty) {
        print(selectedimage);

        try {
          for (int i = 0; i < selectedimage.length; i++) {

            String uniqueFileName =
            DateTime.now().microsecondsSinceEpoch.toString();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('post_images');

            Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);
            await referenceImageToUpload.putFile(File(selectedimage[i].path));
            print(selectedimage[i].path);

            String tempimageUrl = await referenceImageToUpload.getDownloadURL();
            Db_images.add(tempimageUrl);


          }
          setState(() {
            images=Db_images;
          });
        } catch (e) {
          print('Error picking image: $e');
        }
      }
      // if (selectedimage.isEmpty) return;

      // Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white.withOpacity(0.4),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        padding: const EdgeInsets.all(8),
                        backgroundColor: const Color(0xffEC5B5B),
                        shape: const CircleBorder(),
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titlecontroller,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Invalid Field";
                      },
                      decoration: InputDecoration(
                          hintText: "Please Enter Your Title",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: descriptioncontroller,
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
                    const SizedBox(
                      height: 6,
                    ),
                    // widget.Image == null || widget.Image!.isEmpty

                        images.isEmpty
                            ? InkWell(
                                onTap: () => pickImage(),
                                child: Container(
                                    width: 200,
                                    height: 150,
                                    color: Colors.grey,
                                    // child: _image == null
                                    //     ?
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    //     : Image.file(
                                    //   _image!,
                                    //   width: 200,
                                    //   height: 200,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    ),
                              ): FlutterCarousel(
                          options: CarouselOptions(
                            height: size.height * 0.2,
                            initialPage: 0,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: false,
                            enableInfiniteScroll: true,
                            showIndicator: true,
                            autoPlayInterval: const Duration(seconds: 2),
                            slideIndicator: const CircularSlideIndicator(
                              currentIndicatorColor: Color(0XFF00B251),
                              indicatorBackgroundColor: Colors.white,
                              itemSpacing: 17.5,
                            ),
                          ),
                          items: images
                              .map(
                                (item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15)),
                                child: SizedBox(
                                  width: size.width,
                                  height: size.height * 0.2,
                                  child: Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                            // : FlutterCarousel(
                            //     options: CarouselOptions(
                            //       height: size.height * 0.2,
                            //       initialPage: 0,
                            //       viewportFraction: 1.0,
                            //       enlargeCenterPage: false,
                            //       autoPlay: false,
                            //       enableInfiniteScroll: true,
                            //       showIndicator: true,
                            //       autoPlayInterval: const Duration(seconds: 2),
                            //       slideIndicator: const CircularSlideIndicator(
                            //         currentIndicatorColor: Color(0XFF00B251),
                            //         indicatorBackgroundColor: Colors.white,
                            //         itemSpacing: 17.5,
                            //       ),
                            //     ),
                            //     items: images
                            //         .map(
                            //           (item) => Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 1),
                            //             child: ClipRRect(
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(15)),
                            //               child: SizedBox(
                            //                 width: size.width,
                            //                 height: size.height * 0.2,
                            //                 child: Image.file(
                            //                   File(item.path),
                            //                   fit: BoxFit.cover,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         )
                            //         .toList(),
                            //   ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 32,
                                ),
                                foregroundColor: const Color(0xffEC5B5B),
                                side:
                                    const BorderSide(color: Color(0xffEC5B5B))),
                            onPressed: () {
                              setState(() {
                                titlecontroller.clear();
                                descriptioncontroller.clear();
                                images.clear();
                                widget.Image!.clear();
                                pickedImage = null;
                              });
                            },
                            child: const Text("Clear")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xff2A303E),
                                backgroundColor: const Color(0xff5BEC84),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 8)),
                            onPressed: () async {
                              if (widget.isEdit == true) {
                                DateTime now = DateTime.now();
                                String date = DateFormat("yyyy/MM/dd HH:mm").format(now);
                                await PostModel().updatePost(
                                    postID: widget.post_id!,
                                    title: titlecontroller.text,
                                    description: descriptioncontroller.text,
                                    imageURL: Db_images, date: date);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                  (route) => false,
                                );

                              } else {
                                DateTime now = DateTime.now();
                                String date = DateFormat("yyyy/MM/dd HH:mm").format(now);
                                String Id =
                                    (await SharedPrefs().getData('id'))!;
                                int count = await PostModel().getPostCount();
                                await PostModel().addPost(
                                    postID: count,
                                    userID: Id,
                                    title: titlecontroller.text,
                                    description: descriptioncontroller.text,
                                    imageURL: Db_images, date: date);

                                displayToastMessage("Posted", context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            child:
                                Text(widget.isEdit == true ? "Update" : "Post"))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
