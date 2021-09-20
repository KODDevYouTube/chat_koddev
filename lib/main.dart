import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/screens/home_screen.dart';
import 'package:chat_koddev/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helper/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: MATERIAL_COLOR,
        primaryColorDark: COLOR_MAIN,
        fontFamily: 'AppFont',
        iconTheme: IconThemeData(
            color: COLOR_MAIN
        ),
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: COLOR_MAIN
            )
        ),
      ),
      supportedLocales: [
        Locale('en', '')
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales){
        for(var supportedLocale in supportedLocales) {
          if(supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatefulWidget {

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    Map<String, String> session = await AppSession().readSessions();
    Widget route;
    if(session['login'] == 'true'){
      route = HomeScreen();
    } else {
      route = LoginScreen();
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => route)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CYAN,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
    );
  }
}
