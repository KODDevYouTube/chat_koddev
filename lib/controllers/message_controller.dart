import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/message.dart';
import 'package:chat_koddev/models/request.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class MessageController extends GetxController {

  var messageList = List<Message>().obs;
  var isLoading = true.obs;

  fetchMessages(roomId, page) async {
    await RestApi().messages(
        roomId,
        page,
        onResponse: (response) async {
          var requests = List<Message>();
          var list = response['messages'];
          for(var data in list){
            requests.add(Message.fromJson(data));
          }
          await updateMessages(requests, roomId);
        }
    );
  }

  updateSingleMessage(Message message, roomId) async {
    var box = await Hive.openBox(roomId);
    int index = box.values.toList().indexWhere((element) {
        Message msg = Message.fromJson(element);
        return msg.message_id == message.message_id;
      }
    );
    await box.putAt(index, message.toJson());

    messageList[messageList.indexWhere((element) =>
      element.message_id == message.message_id
    )] = message;
  }

  addSingleMessage(Message message, roomId) async {
    var box = await Hive.openBox(roomId);

    int index = box.values.toList().indexWhere((element) {
        Message msg = Message.fromJson(element);
        return msg.message_id == message.message_id;
      }
    );

    if(index == -1) {
      await box.add(message.toJson());
      messageList.add(message);
    }
  }

  updateMessages(uMessageList, roomId) async {
    var box = await Hive.openBox(roomId);
    await box.clear();
    for(Message message in uMessageList){
      await box.add(message.toJson());
    }
    messageList.value = uMessageList;
    isLoading(false);
  }

  getMessages(roomId, firstTime) async {
    List<Map<String, dynamic>> map = await readFromHive(roomId);
    var list = List<Message>();
    for(var message in map) {
      list.add(Message.fromJson(message));
    }
    messageList.value = list;
    if(list.length > 0 || firstTime) {
      isLoading(false);
    }
    await fetchMessages(roomId, 1);
  }

  Future<List<Map<String, dynamic>>> readFromHive(roomId) async {
    final box = await Hive.openBox(roomId);
    final result = box.toMap().map(
          (k, e) => MapEntry(
        k.toString(),
        Map<String, dynamic>.from(e),
      ),
    );

    return result.values.toList();
  }

}