import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/register/step2_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';

class Step1Screen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Step1Screen> {

  var firstNameController = new TextEditingController();
  var lastNameController = new TextEditingController();

  final _validateForm = GlobalKey<FormState>();
  final _validateFirstName = GlobalKey<FormFieldState>();
  final _validateLastName = GlobalKey<FormFieldState>();

  nextScreen() {
    Map<String, String> user = <String, String>{
      "firstname": firstNameController.text,
      "lastname": lastNameController.text
    };
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Step2Screen(user)
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
                    _form(),
                    SizedBox(height: 50),
                    Text(
                      AppLocalizations.of(context).translate('terms_privacy'),
                      style: TextStyle(
                        color: COLOR_TEXT_LIGHT
                      ),
                    ),
                    SizedBox(height: 30),
                    ChatButton(
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context).translate('accept')} & ${AppLocalizations.of(context).translate('continue')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      onClick: () async {
                        if(_validateForm.currentState.validate()){
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
          AppLocalizations.of(context).translate('whats_your_name'),
          style: TextStyle(
            fontSize: 25,
            color: COLOR_MAIN,
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }

  Widget _form(){
    return Form(
      key: _validateForm,
      child: Column(
        children: [
          TextFormField(
            key: _validateFirstName,
            controller: firstNameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('first_name'),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              _validateFirstName.currentState.validate();
            },
            validator: (value) {
              if(value.length < 2) {
                return AppLocalizations.of(context).translate('enter_correct_field');
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: '${AppLocalizations.of(context).translate('last_name')} (${AppLocalizations.of(context).translate('optional')})',
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
