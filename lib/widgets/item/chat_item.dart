import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/chat.dart';
import 'package:chat_koddev/models/room.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/screens/home/message_screen.dart';
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
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        leading: CircleImage(
          width: 50,
          height: 50,
          child: CachedNetworkImage(imageUrl: chat.r_image),
          borderWidth: 0,
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            chat.type == 'chat'
            ? '${chat.r_firstname} ${chat.r_lastname ?? ''}'
            : '${chat.name}',
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
          User user = User(
            id: chat.r_id,
            firstName: chat.r_firstname,
            lastName: chat.r_lastname,
            username: chat.r_username,
            image: chat.r_image,
            email: chat.r_email,
            email_verified: chat.r_email_verified,
            birthday: chat.r_birthday,
          );
          String roomId = chat.room_id;
          Room room = Room(
              room_id: roomId,
              name: chat.name,
              type: chat.type
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MessageScreen(user, room)
          ));
        },
      ),
    );
  }
}
