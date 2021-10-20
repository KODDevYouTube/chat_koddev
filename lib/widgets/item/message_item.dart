
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/controllers/user_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/message.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:chat_koddev/widgets/link_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class MessageItem extends StatelessWidget {

  UserController userController = Get.find();

  final Message message;
  Message messageNext;
  Message messagePrevious;

  DateTime datePrevious;
  DateTime dateCurrent;

  final index;
  final List<Message> messages;

  var onTryAgain;

  MessageItem(this.message, this.index, this.messages, {this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    messageNext = index > 0 ? messages[index-1] : null;
    messagePrevious = index < (messages.length-1) ? messages[index+1] : null;

    datePrevious = messagePrevious != null ? DateTime.fromMillisecondsSinceEpoch(messagePrevious.created * 1000) : null;
    dateCurrent = DateTime.fromMillisecondsSinceEpoch(message.created * 1000);

    return Container(
      child: userController.user.value.id != message.id
        ? _leftItem(context)
        : _rightItem(context),
    );
  }

  Widget _rightItem(BuildContext context){

    LinkText linkText = LinkText(
      text: message.message,
      color: Colors.white,
      onLinkClicked: (){

      },
    );

    return Container(
      child: InkWell(
        onTap: () {

        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(message.status != 'client' && (datePrevious == null || datePrevious.day != dateCurrent.day))
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text(
                        '${DateFormat('MMM dd, yyyy').format(dateCurrent).toUpperCase()}',
                        style: TextStyle(
                          color: COLOR_TEXT_LIGHT,
                          fontSize: 13
                        ),
                      )
                  )
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .7,
                  ),
                  margin: EdgeInsets.only(
                      right: 0,
                      top: messagePrevious != null ? message.id == messagePrevious.id ? 2.0 : 8.0 : 8.0,
                      bottom: messageNext != null ? message.id == messageNext.id ? 2.0 : 8.0 : 8.0,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: COLOR_CYAN,
                    borderRadius: _rightRadius()
                  ),
                  child: Container(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        linkText,
                        Container(
                          padding:  EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${DateFormat('HH:mm').format(dateCurrent).toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black12
                                  ),
                                ),
                                SizedBox(width: 5),
                                _rightStatus()
                              ],
                            )
                          ),
                      ],
                    ),
                  ),
                ),

                if(linkText.getLink() != null)
                  SimpleUrlPreview(
                    url: linkText.getLink(),
                    previewHeight: 130,
                    bgColor: Colors.white,
                  ),
                if(message.status == 'failed')
                  GestureDetector(
                    child: Text(
                      'Try again',
                      style: TextStyle(
                        color: Colors.redAccent
                      ),
                    ),
                    onTap: (){
                      onTryAgain(message);
                    },
                  )
              ]
          ),
        ),
      ),
    );
  }

  Widget _leftItem(BuildContext context){
    return Container(
      child: InkWell(
        onTap: () {

        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if(message.status != 'client' && (datePrevious == null || datePrevious.day != dateCurrent.day))
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Text(
                            '${DateFormat('MMM dd, yyyy').format(dateCurrent).toUpperCase()}',
                            style: TextStyle(
                                color: COLOR_TEXT_LIGHT,
                                fontSize: 13
                            ),
                          )
                      )
                  ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: CircleImage(
                        width: 35,
                        height: 35,
                        child: (messageNext == null || message.id != messageNext.id)
                          ? CachedNetworkImage(imageUrl: message.image)
                          : Container(),
                        borderWidth: 0,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7,
                      ),
                      margin: EdgeInsets.only(
                          left: 8.0,
                          top: messagePrevious != null ? message.id == messagePrevious.id ? 2.0 : 8.0 : 8.0,
                          bottom: messageNext != null ? message.id == messageNext.id ? 2.0 : 8.0 : 8.0,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: _leftRadius(),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: 100 != 0 ? Color(0xFF10000000) : Colors.transparent,
                            blurRadius: 100,
                            offset: Offset(0.0, 0.50),
                        )]
                      ),
                      child: Container(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            LinkText(
                              text: message.message,
                              color: Colors.black,
                              onLinkClicked: (){

                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child:Text(
                                '${DateFormat('HH:mm').format(dateCurrent).toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rightStatus() {

    switch(message.status){
      case 'client':
        return SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueGrey));
        break;
      case 'server':
        return SizedBox(
            height: 15,
            width: 15,
            child: Icon(MdiIcons.checkCircleOutline, color: Colors.blueGrey, size: 15));
            break;
      case 'failed':
        return SizedBox(
            height: 15,
            width: 15,
            child: Icon(Icons.error_outline, color: Colors.redAccent, size: 15));
        break;
    }

    return Container();
  }

  BorderRadius _rightRadius(){
    Radius topLeft = Radius.circular(12.0);
    Radius topRight = Radius.circular(12.0);
    Radius bottomLeft = Radius.circular(12.0);
    Radius bottomRight = Radius.circular(12.0);

    if(messagePrevious != null){
      if(messages[index].id == messagePrevious.id){
        //topLeft = Radius.circular(2.0);
        topRight =  Radius.circular(4.0);
      }
    }

    if(messageNext != null){
      if(messages[index].id == messageNext.id){
        bottomRight =  Radius.circular(4.0);
      }
    }

    return BorderRadius.only(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight
    );
  }

  BorderRadius _leftRadius(){
    Radius topLeft = Radius.circular(12.0);
    Radius topRight = Radius.circular(12.0);
    Radius bottomLeft = Radius.circular(12.0);
    Radius bottomRight = Radius.circular(12.0);

    if(messagePrevious != null){
      if(message.id == messagePrevious.id){
        //topLeft = Radius.circular(2.0);
        topLeft =  Radius.circular(4.0);
      }
    }

    if(messageNext != null){
      if(message.id == messageNext.id){
        bottomLeft =  Radius.circular(4.0);
      }
    }

    return BorderRadius.only(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight
    );
  }
}
