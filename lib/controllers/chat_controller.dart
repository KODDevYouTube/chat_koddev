import 'dart:convert';

import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/chat.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class ChatController extends GetxController {

  var chatList = List<Chat>().obs;
  var isLoading = true.obs;

  fetchChats() async {
    await RestApi().chats(
        onResponse: (response) async {
          var chats = List<Chat>();
          var list = response['chats'];
          for(var data in list){
            chats.add(Chat.fromJson(data));
          }
          await updateChats(chats);
        }
    );
  }

  updateChats(uChatList) async {
    var box = await Hive.openBox('chats');
    await box.clear();
    for(Chat chat in uChatList){
      await box.add(chat.toJson());
    }
    chatList.value = uChatList;
  }

  getChats() async {
    List<Map<String, dynamic>> map = await readFromHive();
    var list = List<Chat>();
    for(var chat in map) {
      list.add(Chat.fromJson(chat));
    }
    chatList.value = list;
    isLoading(false);
    await fetchChats();
  }

  Future<List<Map<String, dynamic>>> readFromHive() async {
    final box = await Hive.openBox('chats');
    final result = box.toMap().map(
          (k, e) => MapEntry(
        k.toString(),
        Map<String, dynamic>.from(e),
      ),
    );

    return result.values.toList();
  }

}