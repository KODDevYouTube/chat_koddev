import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/controllers/request_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/home/friends/online_screen.dart';
import 'package:chat_koddev/screens/home/friends/requests_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {

  RequestController requestController = Get.find();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ChatButton(
                padding: EdgeInsets.all(0),
                color: Colors.white,
                child: TabBar(
                    indicatorWeight: 0,
                    unselectedLabelColor: COLOR_MAIN,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [COLOR_YELLOW, COLOR_YELLOW]
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(AppLocalizations.of(context).translate('friends').toUpperCase()),
                        ),
                      ),
                      Tab(
                        child: Obx(() => requestController.requestList.length > 0
                              ? Badge(
                              elevation: 0,
                              animationType: BadgeAnimationType.scale,
                              position: BadgePosition.topEnd(top: 2),
                              badgeColor: Colors.red.shade300,
                              badgeContent: Text(
                                '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(AppLocalizations.of(context).translate('requests').toUpperCase()),
                              ),
                            ) : Align(
                              alignment: Alignment.center,
                              child: Text(AppLocalizations.of(context).translate('requests').toUpperCase()),
                          )
                        )
                      )
                    ]
                ),
              ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15),
          child: TabBarView(children: [
            OnlineScreen(),
            RequestsScreen()
          ]),
        )
      ),
    );
  }
}
