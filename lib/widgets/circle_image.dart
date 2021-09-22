import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {

  Widget child;
  double width, height;
  double borderWidth;
  Color borderColor;
  Color backgroundColor;

  CircleImage({
    this.child,
    this.width,
    this.height,
    this.borderWidth,
    this.borderColor,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(borderWidth),
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: borderColor
      ),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(300.0),
          child: child,
        ),
      ),
    );
  }
}
