import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:get/state_manager.dart';

class SearchController extends GetxController {

  var userList = List<User>().obs;
  var isLoading = true.obs;

  fetchUsers(text, loading) async {
    if(loading)isLoading(true);
    await RestApi().searchUsers(
        text,
        onResponse: (response) async {
          var users = List<User>();
          var list = response['users'];
          for(var data in list){
            users.add(User.fromJson(data));
          }
          userList.value = users;
        },
        onError: (error) {
          userList.clear();
        }
    );
    isLoading(false);
  }

  clear(){
    userList.clear();
  }
}