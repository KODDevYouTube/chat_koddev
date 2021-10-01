import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/screens/home_screen.dart';
import 'package:chat_koddev/screens/register/step1_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AppProgressDialog appProgressDialog;

  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();

  login() async {
    appProgressDialog.show();

    String emailUser = emailController.text.trim();

    Map<String, String> params = <String, String>{
      if(GetUtils.isEmail(emailUser))
        "email": emailUser,
      if(!GetUtils.isEmail(emailUser))
        "username": emailUser,
      "password": passwordController.text
    };

    await RestApi().login(params,
        onResponse: (response) async {
          await AppApi().login(response);
          appProgressDialog.hide();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()
          ));
        },
        onError: (error) async {
          appProgressDialog.hide();
          GetMessage.snackbarError(error.toString());
        }
    );
  }

  @override
  void initState() {
    appProgressDialog = AppProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _topText(),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate('username_email'),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) async {
                    await login();
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate('password'),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    child: Text(
                      'Forgot your Password?',
                      style: TextStyle(
                        color: COLOR_TEXT_LIGHT,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      //TODO: Forgot Password
                      GetMessage.snackbarSuccess('TODO');
                    },
                  ),
                ),
                SizedBox(height: 30),
                ChatButton(
                  child: Center(
                    child: Text(AppLocalizations.of(context).translate('login'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                    ),
                  ),
                  onClick: () async {
                    await login();
                  },
                ),
                SizedBox(height: 20),
                ChatButton(
                  elevation: 100.0,
                  color: Colors.white,
                  child: Center(
                    child: Text(AppLocalizations.of(context).translate('sign_up'),
                      style: TextStyle(
                          fontSize: 17,
                      ),
                    ),
                  ),
                  onClick: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Step1Screen()
                    ));
                  },
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _topText(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('welcome_back'),
          style: TextStyle(
            fontSize: 25,
            color: COLOR_MAIN,
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).translate('login_account'),
          style: TextStyle(
            fontSize: 17,
            color: COLOR_TEXT_LIGHT,
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }
}
