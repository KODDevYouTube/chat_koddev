import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionListener extends StatefulWidget {

  final child;

  SessionListener({@required this.child});

  @override
  _SessionListenerState createState() => _SessionListenerState();
}

class _SessionListenerState extends State<SessionListener> {

  Map<String, String> session;
  AppProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = AppProgressDialog(context);
    _initSession();
  }

  _initSession() async {
    session = await AppSession().readSessions();
    _checkSession();
    _checkConnection();
  }

  _checkSession() async {
    session = await AppSession().readSessions();
    if(session['login'] == 'true') {
      var expiresAt = session['expiresAt'];
      var now = ((DateTime.now().millisecondsSinceEpoch)/1000).round();
      if(int.parse(expiresAt) < now){
        Get.defaultDialog(
            title: AppLocalizations.of(context).translate('session_expired'),
            titlePadding: EdgeInsets.all(15),
            content: getContent(),
            barrierDismissible: false,
            confirm: confirmBtn(),
            onWillPop: () {
              return null;
            }
        );
      } else {
        print('Valid token');
      }
    }
  }

  _checkConnection() async {
    //TODO: Check connection
  }



  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (_) {
          _checkSession();
          _checkConnection();
        },
        child: widget.child
    );
  }

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('session_expired_content'),
            style: TextStyle(color: COLOR_TEXT_LIGHT),)
        ],
      ),
    );
  }

  Widget confirmBtn() {
    return ChatButton(
      child: Center(
        child: Text(AppLocalizations.of(context).translate('ok'),
          style: TextStyle(
              fontSize: 17,
              color: Colors.white
          ),
        ),
      ),
      onClick: () {
        AppApi().logout(context);
      },
    );
  }

}
