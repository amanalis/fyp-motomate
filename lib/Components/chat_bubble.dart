import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messages;
  const ChatBubble({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(
        messages,
        style: TextStyle(fontSize: 16,color: Colors.white),
      ),
    );
  }
}
