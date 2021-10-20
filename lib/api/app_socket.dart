import 'package:chat_koddev/api/api.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AppSocket {

  static AppSocket _instance;

  Socket socket;

  AppSocket._() {
    socket = io(Api.SOCKET_SERVER, <String, dynamic>{
      'transports': ['websocket'],
      //'autoConnect': true,
    });
    socket.onConnect((_) async {
      await joinMyRoom();
    });
    socket.onDisconnect((_) {
      //socket.emit('msg', 'test');
    });
    socket.connect();
  }

  factory AppSocket() {
    if (_instance == null) {
      _instance = new AppSocket._();
    }
    return _instance;
  }

  joinMyRoom() async {
    Map<String, String> session = await AppSession().readSessions();
    String uid = session['uid'];
    print('room $uid');
    joinRoom(uid);
  }

  //room
  joinRoom(room){
    socket.emit(_Event.ROOM, room);
  }

  //SubscribeChat
  subscribeChat(data) {
    socket.emit(_Event.SUBSCRIBECHAT, data);
  }

  //UnSubscribeChat
  unSubscribeChat(data) {
    socket.emit(_Event.UNSUBSCRIBECHAT, data);
  }

  //User
  onUser(event) {
    socket.on(_Event.USER, (data) {
      event();
    });
  }
  emitUser(data) {
    socket.emit(_Event.USER, data);
  }

  //Chats
  onChats(event) {
    socket.on(_Event.CHATS, (data) {
      event();
    });
  }
  emitChats(data) {
    socket.emit(_Event.CHATS, data);
  }

  //Friends
  onFriends(event) {
    socket.on(_Event.FRIENDS, (data) {
      event();
    });
  }
  emitFriends(data) {
    socket.emit(_Event.FRIENDS, data);
  }

  //Requests
  onRequests(event) {
    socket.on(_Event.REQUESTS, (data) {
      event();
    });
  }
  emitRequests(data) {
    socket.emit(_Event.REQUESTS, data);
  }

  //Message
  onMessage(event) {
    socket.on(_Event.MESSAGE, (data) {
      event(data);
    });
  }
  emitMessage(data) {
    socket.emit(_Event.MESSAGE, data);
  }

  dispose() {
    //socket.close();
    _instance = null;
    //socket.disconnect();
    socket.dispose();
  }

}

class _Event {
  static const USER = 'user';
  static const CHATS = 'chats';
  static const FRIENDS = 'friends';
  static const REQUESTS = 'requests';
  static const ROOM = 'room';
  static const SUBSCRIBECHAT = 'subscribechat';
  static const UNSUBSCRIBECHAT = 'unsubscribechat';
  static const MESSAGE = 'message';
}