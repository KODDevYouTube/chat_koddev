import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class LinkText extends StatelessWidget {

  final text;
  final color;
  final onLinkClicked;

  String link;
  var match;
  var arr;

  var data;

  LinkText({this.text, this.color, this.onLinkClicked}){
    arr = text.split(" ");
    var urlPattern = r"(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+";
    match = new RegExp(urlPattern, caseSensitive: false);
    getLink();
  }

  getLink(){
    for(String s in arr){
      if(match.hasMatch(s)){
        link = s;
        if(!link.startsWith('http://') || !link.startsWith('https://')){
          link = 'http://$link';
        }
        break;
      }
    }
    return link;
  }

  @override
  Widget build(BuildContext context) {

    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          for(int i = 0; i < arr.length; i++)
            match.hasMatch(arr[i])
                ? TextSpan(
                text: '${arr[i]}',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    onLinkClicked();
                  }
            )
                : TextSpan(
              text: '${
                  i > 0 && match.hasMatch(arr[i-1])
                      ? ' ${arr[i]} '
                      : '${arr[i]} '
              }',
              style: TextStyle(
                  color: color,
                  fontSize: 16
              ),
            ),
        ],
      ),
    );
  }

}