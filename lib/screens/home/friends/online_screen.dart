import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/widgets/item/friend_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineScreen extends StatefulWidget {
  @override
  _OnlineScreenState createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {

  FriendController friendController = Get.find();

  @override
  void initState() {
    friendController.getFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() =>
      !friendController.isLoading.value
        ? ListView.builder(
          itemCount: friendController.friendList.length,
          itemBuilder: (BuildContext context, int index){
            Friend friend = friendController.friendList[index];
            if(friend.status == 'done') {
              return FriendItem(friend);
            }
            return Container();
          },
        )
        : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
