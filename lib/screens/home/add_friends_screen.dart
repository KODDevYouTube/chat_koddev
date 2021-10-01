import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFriendsScreen extends StatefulWidget {
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {

  var searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(
            color: COLOR_MAIN, //change your color here
          ),
          title: Center(
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: '${AppLocalizations.of(context).translate('search_here')}...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }
}
