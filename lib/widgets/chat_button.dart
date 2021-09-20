import 'package:chat_koddev/controllers/button_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatButton extends StatelessWidget {

  final Widget child;
  final Color color, circularColor;
  final onClick;

  ChatButton({
    this.child,
    this.color = COLOR_YELLOW,
    this.circularColor = Colors.white,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: color,
          child: InkWell(
            child: _buttonContent(),
            onTap: onClick,
          )
        ),
      ),
    );
  }

  Widget _buttonContent() {
    return Container(
        padding: EdgeInsets.all(15),
        child: child
    );
  }
}
