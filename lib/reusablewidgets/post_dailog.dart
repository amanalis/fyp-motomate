
import 'package:flutter/material.dart';

void Post_Dialog(BuildContext context) async{
  final _formKey = GlobalKey<FormState>();
  return await showDialog(
      context: context,
      builder: (context){
        final TextEditingController _textEditingController = TextEditingController();
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _textEditingController,
                    validator: (value){
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Enter Some Text"),
                  )
                ],
              ),

            ),
          );
        });
      });
}