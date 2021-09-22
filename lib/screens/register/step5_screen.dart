import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/helper/get_message.dart';
import 'package:chat_koddev/screens/home_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Step5Screen extends StatefulWidget {

  var user;

  Step5Screen(this.user);

  @override
  _Step5ScreenState createState() => _Step5ScreenState();
}

class _Step5ScreenState extends State<Step5Screen> {

  AppProgressDialog appProgressDialog;

  var emailController = new TextEditingController();
  final _validateEmail = GlobalKey<FormFieldState>();

  _register() async {
    appProgressDialog.show();

    widget.user['email'] = emailController.text;

    await RestApi().register(widget.user,
        onResponse: (response) async {
          await AppSession().addSessions(
              uid: response['user']['id'],
              token: response['data']['access_token'],
              login: 'true',
              expiresAt: response['data']['expires_in']
          );
          appProgressDialog.hide();
          Navigator.of(context).popUntil((route) => route.isFirst);
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('sign_up')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: COLOR_MAIN, //change your color here
        ),
      ),
      body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    _text(),
                    _field(),
                    SizedBox(height: 50),
                    ChatButton(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate('continue'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      onClick: () async {
                        if(_validateEmail.currentState.validate()){
                          _register();
                        }
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget _text(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).translate('whats_your_email'),
          style: TextStyle(
            fontSize: 25,
            color: COLOR_MAIN,
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }

  _field(){
    return TextFormField(
      key: _validateEmail,
      controller: emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('email'),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        _validateEmail.currentState.validate();
      },
      validator: (value) {
        if(!GetUtils.isEmail(value)){
          return AppLocalizations.of(context).translate('enter_correct_field');
        }
        return null;
      },
    );
  }

}
