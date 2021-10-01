import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/chat_controller.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/chat.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/item/chat_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  ChatController chatController = Get.find();
  FriendController friendController = Get.find();
  AppSocket appSocket;

  @override
  void initState() {
    chatController.getChats();
    appSocket = AppSocket();
    appSocket.onUser(() async {
      await chatController.fetchChats();
      await friendController.fetchFriends();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.all(20),
                    child: ChatButton(
                      elevation: 100.0,
                      color: Colors.white,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(CupertinoIcons.search),
                        title: Text(
                          AppLocalizations.of(context).translate('search_here'),
                          style: TextStyle(
                            color: COLOR_TEXT_LIGHT
                          ),
                        ),
                      ),
                      onClick: () {

                      },
                    ),
                  )
                ])
            )
          ];
        },
        body: Obx(() =>
            !chatController.isLoading.value
            ? ListView.builder(
              itemCount: chatController.chatList.length,
              itemBuilder: (BuildContext context, int index){
                Chat chat = chatController.chatList[index];
                return ChatItem(chat);
                //return Text('Item $index');
              },
            )
          : Center(child: CircularProgressIndicator()),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: COLOR_YELLOW,
        child: Icon(CupertinoIcons.chat_bubble_text_fill),
        onPressed: () {

        },
      ),
    );
  }

}
