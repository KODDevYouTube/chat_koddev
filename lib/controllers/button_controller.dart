import 'package:get/state_manager.dart';

class ButtonController extends GetxController {

  var isLoading = false.obs;

  void setLoading(bool value){
    isLoading(value);
  }

}