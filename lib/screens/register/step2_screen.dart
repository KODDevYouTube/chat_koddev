import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/register/step3_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Step2Screen extends StatefulWidget {

  var user;

  Step2Screen(this.user);

  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {

  var birthdayController = new TextEditingController();
  final _validateBirthday = GlobalKey<FormFieldState>();

  nextScreen() {
    widget.user['birthday'] = birthdayController.text;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Step3Screen(widget.user)
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
                        if(_validateBirthday.currentState.validate()){
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
          AppLocalizations.of(context).translate('when_your_birthday'),
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
    return InkWell(
      child: TextFormField(
        key: _validateBirthday,
        controller: birthdayController,
        textInputAction: TextInputAction.next,
        enabled: false,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('birthday'),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: COLOR_MAIN),
          ),
          suffixIcon: Icon(Icons.keyboard_arrow_down),
          errorStyle: TextStyle(
              color: Colors.red
          ),
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          _validateBirthday.currentState.validate();
        },
        validator: (value) {
          if(value.isEmpty) {
            return AppLocalizations.of(context).translate('enter_correct_field');
          }
          return null;
        },
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        var now = DateTime.now();
        var date = DateTime(now.year - 10, now.month, now.day);
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1920, 1, 1),
            maxTime: date,
            onConfirm: (date) {
              final format = DateFormat('yyyy-MM-dd');
              String time = format.format(date);
              birthdayController.text = time;
              _validateBirthday.currentState.validate();
            },
            currentTime: date
        );
      },
    );
  }

}
