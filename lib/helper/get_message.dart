import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMessage {

  static snackbarSuccess(String message){
    Get.snackbar('Success', message, leftBarIndicatorColor: Colors.green);
  }

  static snackbarError(String message){
    Get.snackbar('Error', message, leftBarIndicatorColor: Colors.red);
  }
}