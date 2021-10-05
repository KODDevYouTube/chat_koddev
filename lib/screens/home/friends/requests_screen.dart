import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/widgets/item/friend_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  FriendController friendController = Get.find();

  @override
  void initState() {
    friendController.getFriends();
    super.initState();
  }

  List<Friend> filterRequests(){
    return friendController.friendList.where((element) =>
      element.status == 'pending' && element.sender_id != element.user_id
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() =>
      !friendController.isLoading.value
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: widget.createState().filterRequests().length,
              itemBuilder: (BuildContext context, int index){
                List<Friend> requests = widget.createState().filterRequests();
                Friend friend = requests[index];
                return FriendItem(friend, isRequest: true);
              },
            )
          : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
