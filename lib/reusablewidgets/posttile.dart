
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostTile();
}

class _PostTile extends State<PostTile>{
  Color _favIconColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                padding:
                const EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 15.0),
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
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 8,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5),
                                height: 8,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 8,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 110,
                        ),
                        Container(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_favIconColor == Colors.grey) {
                                    _favIconColor = Colors.deepOrange;
                                  } else {
                                    _favIconColor = Colors.grey;
                                  }
                                });
                              },
                              icon: Icon(Icons.star),
                              color: _favIconColor,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_favIconColor == Colors.grey) {
                                    _favIconColor = Colors.deepOrange;
                                  } else {
                                    _favIconColor = Colors.grey;
                                  }
                                });
                              },
                              icon: Icon(Icons.favorite),
                              color: _favIconColor,
                            )),
                        Container(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_favIconColor == Colors.grey) {
                                    _favIconColor = Colors.deepOrange;
                                  } else {
                                    _favIconColor = Colors.grey;
                                  }
                                });
                              },
                              icon: Icon(Icons.insert_comment_rounded),
                              color: _favIconColor,
                            )),
                        Container(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_favIconColor == Colors.grey) {
                                    _favIconColor = Colors.deepOrange;
                                  } else {
                                    _favIconColor = Colors.grey;
                                  }
                                });
                              },
                              icon: Icon(Icons.share),
                              color: _favIconColor,
                            ))
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