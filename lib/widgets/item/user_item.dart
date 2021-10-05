import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/controllers/search_controller.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItem extends StatelessWidget {

  SearchController searchController = Get.find();

  final User user;
  final String text;
  AppSocket appSocket;
  AppProgressDialog appProgressDialog;

  UserItem(this.user, {this.text});

  _addFriend() async {
    appProgressDialog.show();
    Map<String, String> params = <String, String>{
      "receiver_id": user.id
    };

    await RestApi().addFriend(
        params,
        onResponse: (response) async {
          appProgressDialog.hide();
          searchController.fetchUsers(text, false);
          appSocket.emitFriends(user.id);
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
          child: CachedNetworkImage(imageUrl: user.image),
          borderWidth: 0,
        ),
        title: Text(
          user.fullName,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        subtitle: Text(
          user.username,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.person_add, color: Colors.white, size: 20),
              label: Text(
                AppLocalizations.of(context).translate('add'),
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
                _addFriend();
              },
            ),
          ],
        ),
        onTap: () {

        },
      ),
    );
  }
}
