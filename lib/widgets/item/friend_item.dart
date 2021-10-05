import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendItem extends StatelessWidget {

  final Friend friend;
  final bool isRequest;
  FriendController friendController = Get.find();
  AppSocket appSocket;
  AppProgressDialog appProgressDialog;

  FriendItem(this.friend, {this.isRequest = false});

  _acceptFriend() async {
    appProgressDialog.show();
    Map<String, String> params = <String, String>{
      "friend_id": friend.friend_id
    };

    await RestApi().acceptFriend(
        params,
        onResponse: (response) async {
          appProgressDialog.hide();
          friendController.fetchFriends();
          appSocket.emitFriends(friend.sender_id);
        },
        onError: (error) async {
          appProgressDialog.hide();
          GetMessage.snackbarError(error.toString());
        }
    );
  }

  _dismissFriend() async {
    appProgressDialog.show();
    Map<String, String> params = <String, String>{
      "friend_id": friend.friend_id
    };

    await RestApi().dismissFriend(
        params,
        onResponse: (response) async {
          appProgressDialog.hide();
          friendController.fetchFriends();
          appSocket.emitFriends(friend.sender_id);
        },
        onError: (error) async {
          appProgressDialog.hide();
          GetMessage.snackbarError(error.toString());
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    appProgressDialog = AppProgressDialog(context);
    appSocket = AppSocket();
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
        trailing: isRequest ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.person_add, color: Colors.white, size: 20),
              label: Text(
                AppLocalizations.of(context).translate('accept'),
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              elevation: 0,
              color: COLOR_CYAN,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              onPressed: (){
                _acceptFriend();
              }
            ),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(CupertinoIcons.clear, color: COLOR_TEXT_LIGHT, size: 18),
              onPressed: () async {
                _dismissFriend();
              },
            )
          ],
        ) : SizedBox(),
        onTap: () {

        },
      ),
    );
  }
}
