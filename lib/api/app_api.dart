import 'package:ars_progress_dialog/dialog.dart';
import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppApi {

  BuildContext context;

  AppApi(this.context);

  logout() async {
    AppProgressDialog progressDialog = AppProgressDialog(context);
    progressDialog.show();
    RestApi restApi = RestApi();
    await restApi.logout(
      onResponse: (response) {
        print(response['message']);
      },
      onError: (error) {
        print(error);
      }
    );
    await AppSession().addSessions(login: 'false');
    progressDialog.hide();

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()
    ));
  }

}