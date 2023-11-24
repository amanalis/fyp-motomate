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
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 200,
              width: 332,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 8,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                height: 8,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 8,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 110,
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
