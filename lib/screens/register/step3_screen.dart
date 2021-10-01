import 'dart:async';

import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/register/step4_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Step3Screen extends StatefulWidget {

  var user;

  Step3Screen(this.user);

  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {

  var usernameController = new TextEditingController();

  UsernameState _usernameState = UsernameState.START;

  Timer timer;

  nextScreen() {
    widget.user['username'] = usernameController.text.toLowerCase();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Step4Screen(widget.user)
    ));
  }

  @override
  void dispose() {
    if(timer != null) timer.cancel();
    super.dispose();
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
                    _textValidate(),
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
                        if(_usernameState == UsernameState.AVAILABLE){
                          nextScreen();
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
          AppLocalizations.of(context).translate('pick_username'),
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
    return TextField(
      controller: usernameController,
      maxLength: 20,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('username'),
      ),
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      ],
      onChanged: (value) {
        if(timer != null) timer.cancel();
        setState(() {
          _usernameState = UsernameState.LOADING;
        });
        timer = Timer(Duration(milliseconds: 1500), () {
          _checkUsername();
        });
      },
    );
  }

  _textValidate(){
    if (_usernameState == UsernameState.START) {
      return Container();
    } else {
      return Container(
        child: _usernameState == UsernameState.LOADING
          ? Align(
          alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          )
          : SizedBox(
            height: 20,
            child: Text(
              _usernameState == UsernameState.AVAILABLE
                ? AppLocalizations.of(context).translate('username_available')
                : AppLocalizations.of(context).translate('username_unavailable'),
              style: TextStyle(
                color: _usernameState == UsernameState.AVAILABLE
                    ? Colors.green
                    : Colors.red
              ),
            ),
          ),
      );
    }
  }

  _checkUsername() async {
    Map<String, String> params = <String, String>{
      "username": usernameController.text
    };
    await RestApi().checkUsername(
      params,
      onResponse: (response) {
        print(response['message']);
        setState(() {
          _usernameState = UsernameState.AVAILABLE;
        });
      },
      onError: (error) {
        setState(() {
          _usernameState = UsernameState.UNAVAILABLE;
        });
      }
    );
  }

}

enum UsernameState {
  START,
  LOADING,
  AVAILABLE,
  UNAVAILABLE
}
