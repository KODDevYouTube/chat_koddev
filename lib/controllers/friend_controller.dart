import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class FriendController extends GetxController {

  var friendList = List<Friend>().obs;
  var isLoading = true.obs;

  fetchFriends() async {
    await RestApi().friends(
        onResponse: (response) async {
          var friends = List<Friend>();
          var list = response['friends'];
          for(var data in list){
            friends.add(Friend.fromJson(data));
          }
          await updateFriends(friends);
        }
    );
  }

  updateFriends(uFriendList) async {
    var box = await Hive.openBox('friends');
    await box.clear();
    for(Friend friend in uFriendList){
      await box.add(friend.toJson());
    }
    friendList.value = uFriendList;
  }

  getFriends() async {
    List<Map<String, dynamic>> map = await readFromHive();
    var list = List<Friend>();
    for(var friend in map) {
      list.add(Friend.fromJson(friend));
    }
    friendList.value = list;
    isLoading(false);
    await fetchFriends();
  }

  Future<List<Map<String, dynamic>>> readFromHive() async {
    final box = await Hive.openBox('friends');
    final result = box.toMap().map(
          (k, e) => MapEntry(
        k.toString(),
        Map<String, dynamic>.from(e),
      ),
    );

    return result.values.toList();
  }

}