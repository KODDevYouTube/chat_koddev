import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/room.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/screens/home/message_screen.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendItem extends StatelessWidget {
  final Friend friend;

  FriendItem(this.friend);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20),
        leading: CircleImage(
          width: 40,
          height: 40,
          child: CachedNetworkImage(imageUrl: friend.image),
          borderWidth: 0,
        ),
        title: Text(
          '${friend.firstname} ${friend.lastname ?? ''}',
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        subtitle: Text(
          friend.username,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        onTap: () {
          User user = User.fromJson(friend.toJson());
          String roomId = friend.room ?? null;
          Room room = Room(
            room_id: roomId,
            type: 'chat'
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MessageScreen(user, room)
          ));
        },
      ),
    );
  }
}
