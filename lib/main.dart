import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/chat_controller.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/controllers/message_controller.dart';
import 'package:chat_koddev/controllers/participant_controller.dart';
import 'package:chat_koddev/controllers/request_controller.dart';
import 'package:chat_koddev/controllers/search_controller.dart';
import 'package:chat_koddev/controllers/user_controller.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/screens/home_screen.dart';
import 'package:chat_koddev/screens/login_screen.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'helper/colors.dart';

void main() async {

  //init Hive
  await Hive.initFlutter();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

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
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
        Get.put(ChatController());
        Get.put(FriendController());
        Get.put(RequestController());
        Get.put(SearchController());
        Get.put(MessageController());
        Get.put(ParticipantController());
      }),
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
