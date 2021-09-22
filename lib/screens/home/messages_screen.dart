import 'package:chat_koddev/helper/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: COLOR_YELLOW,
        child: Icon(CupertinoIcons.chat_bubble_text_fill),
        onPressed: () {

        },
      ),
    );
  }

}
