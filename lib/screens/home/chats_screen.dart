import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/chat_controller.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/chat.dart';
import 'package:chat_koddev/screens/home/new_message_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/item/chat_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  ChatController chatController = Get.find();

  @override
  void initState() {
    chatController.getChats();
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
            ? chatController.chatList.length > 0
            ? ListView.builder(
              itemCount: chatController.chatList.length,
              itemBuilder: (BuildContext context, int index){
                Chat chat = chatController.chatList[index];
                return ChatItem(chat);
                //return Text('Item $index');
              },
            )
            : _emptyChats()
          : Center(child: CircularProgressIndicator()),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: COLOR_YELLOW,
        child: Icon(CupertinoIcons.chat_bubble_text_fill),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewMessageScreen()
          ));
        },
      ),
    );
  }

  Widget _emptyChats(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              height: 100,
              child: Image.asset('assets/images/emptychat.png'),
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              AppLocalizations.of(context).translate('no_messages_inbox'),
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
              child: Text(AppLocalizations.of(context).translate('send_new_message'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),
            ),
            onClick: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewMessageScreen()
              ));
            },
          ),
        ],
      ),
    );
  }

}
