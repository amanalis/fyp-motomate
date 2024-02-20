import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:motomate/reusablewidgets/post_dailog.dart';
import 'package:motomate/screens/Admin/post_to_approve.dart';
import 'package:motomate/utils/flutter_toast.dart';

import '../../utils/database.dart';

class AdminPosttile extends StatefulWidget {
  const AdminPosttile(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.profileUrl,
      required this.title,
      required this.date,
      required this.Description,
      required this.isHomeScreen,
      required this.userID,
      required this.post_id,
      this.isLiked,
      required this.isApproved,
      required this.isApprovingPost,
      required this.YOM,
      required this.CC, required this.companyname, required this.email});

  final List imageUrl;
  final String name;
  final String profileUrl;
  final String title;
  final String date;
  final String Description;
  final bool isHomeScreen;
  final String userID;
  final String post_id;
  final bool? isLiked;
  final bool isApproved;
  final bool isApprovingPost;
  final String YOM;
  final String CC;
  final String companyname;
  final String email;

  @override
  State<AdminPosttile> createState() => _AdminPosttileState();
}

class _AdminPosttileState extends State<AdminPosttile> {
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
                      ],
                    ),
                  ),
                ),
                widget.isApprovingPost == true
                    ? IconButton(
                        onPressed: () async {
                          await PostModel().updatePost(
                            date: widget.date,
                            postID: widget.post_id,
                            title: widget.title,
                            description: widget.Description,
                            imageURL: widget.imageUrl,
                            isApproved: true,
                            YOM: widget.YOM,
                            CC: widget.CC,
                            companyname: widget.companyname
                          );
                          displayToastMessage("Post Approved!", context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostToApprove(),
                              ));
                        },
                        icon: Icon(
                          Icons.check_circle_outline_outlined,
                          color: Colors.green,
                          size: 35,
                        ),
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
                IconButton(
                  onPressed: () async {
                    await PostModel().delete_post(widget.post_id);
                    displayToastMessage("Post Deleted!", context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostToApprove(),
                        ));
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 35,
                  ),
                )
              ],
            ),
            Text(widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,decoration: TextDecoration.underline),),
            Text(widget.Description,
              style: TextStyle(fontSize: 16),),
            Row(
              children: [
                Text("CompanyName: ${widget.companyname} ",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Year ${widget.YOM} ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.CC,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            FlutterCarousel(
              options: CarouselOptions(
                height: size.height * 0.3,
                initialPage: 0,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: false,
                enableInfiniteScroll: true,
                showIndicator: true,
                allowImplicitScrolling: false,
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
                          height: size.height * 0.3,
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
          ],
        ),
      ),
    );
  }
}
