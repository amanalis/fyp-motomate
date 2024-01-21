import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/screens/profile.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/shared_prefs.dart';

class PostTile extends StatefulWidget {
  PostTile(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.profileUrl,
      required this.title,
      required this.Description,
      required this.isHomeScreen,
      required this.userID,
      required this.post_id,
      required this.date,
      required this.isLiked,
      required this.isApproved});

  final List imageUrl;
  final String name;
  final String profileUrl;
  final String title;
  final String date;
  final String Description;
  final bool isHomeScreen;
  final String userID;
  final String post_id;
  final bool isLiked;
  final bool isApproved;

  @override
  State<StatefulWidget> createState() => _PostTile();
}

class _PostTile extends State<PostTile> {
  Color _favIconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: size.height * 0.5,
      width: size.width * 0.931,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 7.0, 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.profileUrl),
                  ),
                ),
                // ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: size.height * 0.008,
                        //   width: size.width * 0.1,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // Container(
                        //   margin:
                        //       const EdgeInsets.only(top: 5, bottom: 5),
                        //   height: size.height * 0.008,
                        //   width: size.width * 0.18,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // Container(
                        //   height: size.height * 0.008,
                        //   width: size.width * 0.1,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) =>
                      [PopupMenuItem(child: Text("Report the post."))],
                ),
                widget.isHomeScreen
                    ? SizedBox(width: 0, height: 0)
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDailog(
                                      title: widget.title,
                                      Description: widget.Description,
                                      Image: widget.imageUrl,
                                      isEdit: true,
                                      post_id: widget.post_id,
                                      isApproved: widget.isApproved),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            color: _favIconColor,
                          ),
                          IconButton(
                            onPressed: () {
                              UserModel().delete_liked_post_id(
                                  post_id: widget.post_id,
                                  userID: widget.userID);
                              PostModel().delete_post(widget.post_id);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ));
                            },
                            icon: const Icon(Icons.delete_outline),
                            color: _favIconColor,
                          ),
                        ],
                      ),
              ],
            ),
            Text(widget.title),
            Text(widget.Description),
            FlutterCarousel(
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
              items: widget.imageUrl
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_favIconColor == Colors.grey) {
                        _favIconColor = Color(0xffFC0202);
                      } else {
                        _favIconColor = Colors.grey;
                      }
                    });
                    print(
                      widget.post_id,
                    );
                    print(widget.userID);
                    UserModel().updateLikedPostId(
                        postId: widget.post_id, userID: widget.userID);
                  },
                  icon: const Icon(Icons.favorite),
                  color: widget.isLiked ? Color(0xffFC0202) : _favIconColor,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.insert_comment_rounded),
                  color: Colors.grey,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  color: Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
