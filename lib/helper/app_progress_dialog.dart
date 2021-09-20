import 'package:ars_progress_dialog/dialog.dart';
import 'package:flutter/material.dart';

class AppProgressDialog {

  ArsProgressDialog arsProgressDialog;

  final BuildContext context;

  AppProgressDialog(this.context){
    /*Future.delayed(Duration.zero, () {
      _constructor();
    });*/
    _constructor();
  }

  _constructor(){
    arsProgressDialog = ArsProgressDialog(
        context,
        backgroundColor: Colors.transparent,
        blur: 3,
        dismissable: false
    );
  }

  show() {
    if(arsProgressDialog.isShowing){
      arsProgressDialog.dismiss();
    }
    arsProgressDialog.show();
  }

  hide() {
    arsProgressDialog.dismiss();
  }

}