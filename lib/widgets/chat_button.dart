import 'package:chat_koddev/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatButton extends StatelessWidget {

  final Widget child;
  final Color color, circularColor;
  final onClick;
  final EdgeInsetsGeometry padding;
  final double elevation;

  ChatButton({
    this.child,
    this.color = COLOR_YELLOW,
    this.circularColor = Colors.white,
    this.padding = const EdgeInsets.all(15),
    this.elevation = 0.0,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: <BoxShadow>[
          BoxShadow(
            color: elevation != 0 ? Color(0xFF10000000) : Colors.transparent,
            blurRadius: elevation,
            offset: Offset(0.0, elevation != 0 ? 0.50 : 0.0),
        )]
    ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: color,
          child: onClick != null
            ? InkWell(
              child: _buttonContent(),
              onTap: onClick,
            )
            : Container(
            child: _buttonContent(),
          )
        ),
      ),
    );
  }

  Widget _buttonContent() {
    return Container(
        padding: padding,
        child: child
    );
  }
}
