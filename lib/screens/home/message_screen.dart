import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/controllers/chat_controller.dart';
import 'package:chat_koddev/controllers/message_controller.dart';
import 'package:chat_koddev/controllers/participant_controller.dart';
import 'package:chat_koddev/controllers/user_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/message.dart';
import 'package:chat_koddev/models/room.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:chat_koddev/widgets/item/message_item.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {

  User user;
  Room room;

  MessageScreen(this.user, this.room);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  MessageController messageController = Get.find();
  UserController userController = Get.find();
  ChatController chatController = Get.find();
  ParticipantController participantController = Get.find();

  AppSocket appSocket;

  var uuid;
  TextEditingController textController = TextEditingController();
  String roomId;
  bool firstTime = false;

  ScrollController _controller;
  int page = 1;
  bool _isLoadMoreRunning = false;

  bool _isVisible = false;
  bool _isOpaque = false;

  @override
  void initState() {
    appSocket = AppSocket();
    appSocket.onMessage((data) async {
      Map<String, String> params = <String, String>{
        "room_id": roomId,
        "message_id": data['message_id']
      };
      await RestApi().messageById(
          params,
          onResponse: (response) async {
            print(response);
            Message msg = Message.fromJson(response['chat_message'][0]);
            messageController.addSingleMessage(msg, roomId);
          }
      );
    });

    uuid = Uuid();
    roomId = widget.room.room_id;
    if(widget.room.room_id == null){
      roomId = uuid.v4();
      firstTime = true;
    }
    appSocket.subscribeChat(roomId);
    messageController.getMessages(roomId, firstTime);
    participantController.getParticipants(roomId);

    _controller = new ScrollController()..addListener(_loadMore);

    super.initState();
  }

  void _createRoom(Message message) async {
    Map<String, String> params = <String, String>{
      "room_id": roomId,
      "user_id": widget.user.id
    };
    await RestApi().createFriendRoom(
        params,
        onResponse: (response) async {
          await participantController.getParticipants(roomId);
          _sendMessage(message);
        }
    );
  }

  void _sendMessage(Message message) async {
    Map<String, String> params = <String, String>{
      "room_id": roomId,
      "new_message": message.message,
      "new_message_id": message.message_id
    };
    await RestApi().sendMessage(
        params,
        onResponse: (response) async {
          Message msg = Message.fromJson(response['chat_message'][0]);
          messageController.updateSingleMessage(msg, roomId);
          var data = {
            'room': roomId,
            'message_id': msg.message_id,
            'participants': participantController.participantsList.map((element) => element.toJson()).toList()
          };
          print(data);
          appSocket.emitMessage(data);
        },
      onError: (error) {
          message.status = 'failed';
          messageController.updateSingleMessage(message, roomId);
      }
    );
  }

  Message _initMessage(){
    User user = userController.user.value;
    String messageId = uuid.v4();
    Message message = Message(
        message_id: messageId,
        message: textController.text.trim(),
        status: 'client',
        created: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
        id: user.id,
        firstname: user.firstName,
        lastname: user.lastName,
        username: user.username,
        image: user.image,
        email: user.email,
        email_verified: user.email_verified,
        birthday: user.birthday
    );
    messageController.addSingleMessage(message, roomId);
    return message;
  }

  void _loadMore() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      page += 1;
      await messageController.fetchMessages(roomId, page);
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
    if(_controller.position.pixels == _controller.position.minScrollExtent) {
      if(_isOpaque) {
        setState(() {
          _isOpaque = false;
        });
      }
    } else {
      if(!_isVisible){
        setState(() {
          _isVisible = true;
          _isOpaque = true;
        });
      }
    }
  }

  @override
  void dispose() {
    appSocket.unSubscribeChat(roomId);
    messageController.isLoading(true);
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: COLOR_MAIN, //change your color here
          ),
          title: _appBar()
        ),
        body: SafeArea(
          child: Container(
            child: _content(),
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 50),
          child: AnimatedOpacity(
            opacity: _isOpaque ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            onEnd: (){
              if(!_isOpaque)
                setState((){
                  _isVisible = false;
                });
            },
            child: Visibility(
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                child: Icon(CupertinoIcons.down_arrow, color: COLOR_YELLOW),
                onPressed: () {
                  _controller.animateTo(
                    _controller.position.minScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                },
              ),
              visible: _isVisible,
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      leading: CircleAvatar(
        child: CircleImage(
          width: 40,
          height: 40,
          child: CachedNetworkImage(imageUrl: widget.user.image),
          borderWidth: 0,
        ),
      ),
      title: Text(
        _title(),
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
      ),
      subtitle: _subtitle(),
    );
  }

  String _title(){
    switch (widget.room.type){
      case 'room':
        return widget.room.name;
    }
    return widget.user.fullName;
  }

  Widget _subtitle(){
    switch (widget.room.type){
      case 'room':
        return Obx(() => Text('${participantController.participantsList.length} participants'));
    }
    return Text(widget.user.username);
  }

  Widget _content(){
    return Container(
      child: Obx(() =>
        !messageController.isLoading.value
            ? messageController.messageList.length > 0
            ? _messages()
          : _emptyChat()
          : Center(child: CircularProgressIndicator()),
        )
    );
  }

  Widget _messages(){
    return Column(
      children: [
        if(_isLoadMoreRunning)
          Container(
            padding: EdgeInsets.all(5),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1)
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            padding: EdgeInsets.only(bottom: 10),
            reverse: true,
            itemCount:  messageController.messageList.length,
            itemBuilder: (BuildContext context, int index){
              Message message = messageController.messageList[messageController.messageList.length - index - 1];
              return MessageItem(
                message,
                index,
                messageController.messageList.reversed.toList(),
                onTryAgain: (Message message) {
                    message.status = 'client';
                    _sendMessage(message);
                },
              );
            },
          ),
        ),
        _bottomField()
      ],
    );
  }

  Widget _emptyChat() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text('Empty'),
          ),
        ),
        _bottomField()
      ],
    );
  }

  Widget _bottomField(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: ChatButton(
        elevation: 500.0,
        color: Colors.white,
        padding: EdgeInsets.all(2),
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.emoji_emotions_outlined),
                onPressed: (){

                }
            ),
            Expanded(
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration.collapsed(
                    hintText: 'Type a message...'
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            IconButton(
                padding: EdgeInsets.all(5),
                icon: ChatButton(
                  elevation: 0,
                  padding: EdgeInsets.all(0),
                  color: COLOR_YELLOW,
                  child: Center(
                      child: textController.text.trim().length > 0
                        ? Icon(Icons.send, color: Colors.white)
                        : Icon(Icons.mic, color: Colors.white)
                  ),
                ),
                onPressed: (){
                  if(textController.text.trim().isNotEmpty) {
                    Message message = _initMessage();
                    textController.text = '';
                    if (firstTime) {
                      firstTime = false;
                      _createRoom(message);
                    } else {
                      _sendMessage(message);
                    }
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
