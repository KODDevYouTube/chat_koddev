import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/request.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class RequestController extends GetxController {

  var requestList = List<Request>().obs;
  var isLoading = true.obs;

  fetchRequests() async {
    await RestApi().requests(
        onResponse: (response) async {
          var requests = List<Request>();
          var list = response['requests'];
          for(var data in list){
            requests.add(Request.fromJson(data));
          }
          await updateRequests(requests);
        }
    );
  }

  updateRequests(uFriendList) async {
    var box = await Hive.openBox('requests');
    await box.clear();
    for(Request friend in uFriendList){
      await box.add(friend.toJson());
    }
    requestList.value = uFriendList;
  }

  getRequests() async {
    List<Map<String, dynamic>> map = await readFromHive();
    var list = List<Request>();
    for(var friend in map) {
      list.add(Request.fromJson(friend));
    }
    requestList.value = list;
    isLoading(false);
    await fetchRequests();
  }

  Future<List<Map<String, dynamic>>> readFromHive() async {
    final box = await Hive.openBox('requests');
    final result = box.toMap().map(
          (k, e) => MapEntry(
        k.toString(),
        Map<String, dynamic>.from(e),
      ),
    );

    return result.values.toList();
  }

}