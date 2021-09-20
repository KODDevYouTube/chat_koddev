import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    AppSession().readSessions().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                leading: CircleAvatar(
                  child: CircularProgressIndicator(),
                ),
                title: Text('Majlindi'),
                trailing: Icon(CupertinoIcons.bell, color: COLOR_MAIN),
                onTap: () {
                  AppApi(context).logout();
                },
              ),
              Expanded(
               child: Container(
                 padding: EdgeInsets.only(left: 20, right: 20),
               ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
