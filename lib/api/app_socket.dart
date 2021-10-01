import 'package:chat_koddev/api/api.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AppSocket {

  static AppSocket _instance;

  Socket socket;

  AppSocket._() {
    socket = io(Api.SOCKET_SERVER, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) async {
      Map<String, String> session = await AppSession().readSessions();
      String uid = session['uid'];
      socket.emit(_Event.ROOM, uid);
    });
    socket.onDisconnect((_) {
      //socket.emit('msg', 'test');
    });
  }

  factory AppSocket() {
    if (_instance == null) {
      _instance = new AppSocket._();
    }
    return _instance;
  }


  onUser(event) {
    socket.on(_Event.USER, (data) {
      event();
    });
  }

  emitUser(data) {
    socket.emit(_Event.USER, data);
  }

  dispose() {
    print("Socket dispose");
    socket.dispose();
  }

}

class _Event {
  static const USER = 'user';
  static const ROOM = 'room';
}