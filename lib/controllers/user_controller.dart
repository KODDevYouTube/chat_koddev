import 'package:chat_koddev/api/rest_api.dart';
import '../models/user.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserController extends GetxController{

  var user = User().obs;
  var isLoading = true.obs;

  fetchUser() async {
    //await AppApi(context).refreshToken();
    await RestApi().me(
      onResponse: (response) async {
        User u = User.fromJson(response['user']);
        await updateUser(u);
      }
    );
  }

  updateUser(u) async {
    var box = await Hive.openBox('user');
    await box.clear();
    await box.add(u.toJson());
    user.value = u;
  }

  getUser() async {
    var box = await Hive.openBox('user');
    var u = box.toMap()[0]?.cast<String, dynamic>() ?? null;
    user.value = User.fromJson(u);
    isLoading(false);
    await fetchUser();
  }

}