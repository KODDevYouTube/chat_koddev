import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/message.dart';
import 'package:chat_koddev/models/request.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class ParticipantController extends GetxController {

  var participantsList = List<User>().obs;

  fetchParticipants(roomId) async {
    await RestApi().participants(
        roomId,
        onResponse: (response) async {
          var participants = List<User>();
          var list = response['participants'];
          for(var data in list){
            participants.add(User.fromJson(data));
          }
          await updateParticipants(participants, roomId);
        }
    );
  }

  updateParticipants(uParticipantList, roomId) async {
    var box = await Hive.openBox('p-$roomId');
    await box.clear();
    for(User user in uParticipantList){
      await box.add(user.toJson());
    }
    participantsList.value = uParticipantList;
  }

  getParticipants(roomId) async {
    List<Map<String, dynamic>> map = await readFromHive(roomId);
    var list = List<User>();
    for(var user in map) {
      list.add(User.fromJson(user));
    }
    participantsList.value = list;
    await fetchParticipants(roomId);
  }

  Future<List<Map<String, dynamic>>> readFromHive(roomId) async {
    final box = await Hive.openBox('p-$roomId');
    final result = box.toMap().map(
          (k, e) => MapEntry(
        k.toString(),
        Map<String, dynamic>.from(e),
      ),
    );

    return result.values.toList();
  }

}