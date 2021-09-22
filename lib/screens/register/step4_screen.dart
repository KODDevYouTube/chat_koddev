import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/register/step5_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';

class Step4Screen extends StatefulWidget {

  var user;

  Step4Screen(this.user);

  @override
  _Step4ScreenState createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {

  var passwordController = new TextEditingController();
  final _validatePassword = GlobalKey<FormFieldState>();

  nextScreen() {
    widget.user['password'] = passwordController.text;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Step5Screen(widget.user)
    ));
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
                        if(_validatePassword.currentState.validate()){
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
          AppLocalizations.of(context).translate('set_password'),
          style: TextStyle(
            fontSize: 25,
            color: COLOR_MAIN,
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).translate('password_length'),
          style: TextStyle(
            fontSize: 17,
            color: COLOR_TEXT_LIGHT,
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }

  _field(){
    return TextFormField(
      key: _validatePassword,
      controller: passwordController,
      maxLength: 30,
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('password'),
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        _validatePassword.currentState.validate();
      },
      validator: (value) {
        if(value.length < 6){
          return AppLocalizations.of(context).translate('enter_correct_field');
        }
        return null;
      },
    );
  }

}
