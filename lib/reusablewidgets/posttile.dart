import 'package:flutter/material.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key});

  @override
  State<StatefulWidget> createState() => _PostTile();
}

class _PostTile extends State<PostTile> {
  Color _favIconColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: size.height * 0.25,
              width: size.width * 0.931,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 7.0, 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.05,
                          width: size.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.deepOrange,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: size.height * 0.008,
                                width: size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                height: size.height * 0.008,
                                width: size.width * 0.18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: size.height * 0.008,
                                width: size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_favIconColor == Colors.grey) {
                                _favIconColor = Colors.deepOrange;
                              } else {
                                _favIconColor = Colors.grey;
                              }
                            });
                          },
                          icon: const Icon(Icons.star),
                          color: _favIconColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_favIconColor == Colors.grey) {
                                _favIconColor = Colors.deepOrange;
                              } else {
                                _favIconColor = Colors.grey;
                              }
                            });
                          },
                          icon: const Icon(Icons.favorite),
                          color: _favIconColor,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_favIconColor == Colors.grey) {
                                _favIconColor = Colors.deepOrange;
                              } else {
                                _favIconColor = Colors.grey;
                              }
                            });
                          },
                          icon: const Icon(Icons.insert_comment_rounded),
                          color: _favIconColor,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_favIconColor == Colors.grey) {
                                _favIconColor = Colors.deepOrange;
                              } else {
                                _favIconColor = Colors.grey;
                              }
                            });
                          },
                          icon: const Icon(Icons.share),
                          color: _favIconColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
