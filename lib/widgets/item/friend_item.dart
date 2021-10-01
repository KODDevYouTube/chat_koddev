import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/material.dart';

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
          child: CachedNetworkImage(imageUrl: friend.u_image),
          borderWidth: 0,
        ),
        title: Text(
          '${friend.u_firstname} ${friend.u_lastname ?? ''}',
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        subtitle: Text(
          friend.u_username,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        onTap: () {

        },
      ),
    );
  }
}
