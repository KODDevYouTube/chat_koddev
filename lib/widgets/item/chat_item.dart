import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/chat.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class ChatItem extends StatelessWidget {

  final Chat chat;

  ChatItem(this.chat);

  @override
  Widget build(BuildContext context) {

    var date = new DateTime.fromMillisecondsSinceEpoch(chat.message_created*1000);

    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        leading: CircleImage(
          width: 55,
          height: 55,
          child: CachedNetworkImage(imageUrl: chat.r_image),
          borderWidth: 0,
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            '${chat.r_firstname} ${chat.r_lastname ?? ''}',
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        subtitle: Text(
          chat.message,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        trailing:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${timeago.format(date, locale: 'en_short')}',
              style: TextStyle(
                color: COLOR_TEXT_LIGHT
              ),
            ),
          ],
        ),
        onTap: () {

        },
      ),
    );
  }
}
