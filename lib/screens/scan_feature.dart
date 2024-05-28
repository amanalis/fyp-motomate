import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class Scan_Feature extends StatefulWidget {
  const Scan_Feature({super.key});

  @override
  State<Scan_Feature> createState() => _Scan_FeatureState();
}

class _Scan_FeatureState extends State<Scan_Feature> {
  List? pickedImage;
  List images = [];
  List Db_images = [];

  void selectImages() async {
    final List selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      images.addAll(selectedImages);
    }
    setState(() {});
  }

  void pickImage() async {
    try {
      final List selectedimage = await ImagePicker().pickMultiImage();

      if (selectedimage.isNotEmpty) {
        print(selectedimage);

        try {
          for (int i = 0; i < selectedimage.length; i++) {
            String uniqueFileName =
                DateTime.now().microsecondsSinceEpoch.toString();

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('scan_images');

            Reference referenceImageToUpload =
                referenceDirImages.child(uniqueFileName);
            await referenceImageToUpload.putFile(File(selectedimage[i].path));
            print(selectedimage[i].path);

            String tempimageUrl = await referenceImageToUpload.getDownloadURL();
            Db_images.add(tempimageUrl);
          }
          setState(() {
            images = Db_images;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text("Scan Parts",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset("assets/icons/scan.svg",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 90.0),
        child: Column(
          children: [
            Spacer(),
            images.isEmpty
                ? InkWell(
                    onTap: () => pickImage(),
                    child: Container(
                      width: 300,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent.shade100,
                      ),
                      // child: _image == null
                      //     ?
                      child: const Center(
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
                      ),
                    ),
                  )
                : FlutterCarousel(
                    options: CarouselOptions(
                      height: size.height * 0.4,
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
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  minimumSize: const Size(double.infinity, 56),
                ),
                onPressed: () async {},
                child: Text(
                  "SCAN",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      )),
    );
  }
}
