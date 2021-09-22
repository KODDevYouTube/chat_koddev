import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/models/User.dart';
import 'package:get/state_manager.dart';

class UserController extends GetxController{

  var isLoading = true.obs;
  var user = User().obs;

  fetchMe() async {
    isLoading(true);
    await RestApi().me(
      onResponse: (response){
        User u = User.fromJson(response['user']);
        user.value = u;
      }
    );
    isLoading(false);
  }

}