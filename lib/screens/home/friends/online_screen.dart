import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/screens/home/add_friends_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/item/friend_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineScreen extends StatefulWidget {
  @override
  _OnlineScreenState createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {

  FriendController friendController = Get.find();
  AppProgressDialog appProgressDialog;

  @override
  void initState() {
    friendController.getFriends();
    appProgressDialog = AppProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() =>
      !friendController.isLoading.value
        ? friendController.friendList.length > 0
          ? ListView.builder(
            itemCount:  friendController.friendList.length,
            itemBuilder: (BuildContext context, int index){
              Friend friend = friendController.friendList[index];
              return FriendItem(friend);
            },
          )
        : _emptyFriends()
        : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _emptyFriends(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              height: 100,
              child: Image.asset('assets/images/emptyfriends.png'),
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              AppLocalizations.of(context).translate('no_friends_yet'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: COLOR_TEXT_LIGHT
              ),
            ),
          ),
          SizedBox(height: 20),
          ChatButton(
            color: COLOR_CYAN,
            child: Center(
              child: Text(AppLocalizations.of(context).translate('add_new_friend'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),
            ),
            onClick: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddFriendsScreen()
              ));
            },
          ),
        ],
      ),
    );
  }

}
