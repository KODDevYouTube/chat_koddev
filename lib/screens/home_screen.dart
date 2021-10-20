import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/api/app_socket.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/chat_controller.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/controllers/request_controller.dart';
import 'package:chat_koddev/controllers/user_controller.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/home/add_friends_screen.dart';
import 'package:chat_koddev/screens/home/chats_screen.dart';
import 'package:chat_koddev/screens/home/friends_screen.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  UserController userController = Get.find();
  ChatController chatController = Get.find();
  FriendController friendController = Get.find();
  RequestController requestController = Get.find();
  AppSocket appSocket;

  int _selectedIndex = 0;

  @override
  void initState() {
    userController.getUser();
    appSocket = AppSocket();
    appSocket.joinMyRoom();
    appSocket.onUser(() async {
      await userController.fetchUser();
    });
    appSocket.onChats(() {
      chatController.fetchChats();
    });
    appSocket.onFriends(() async {
      await friendController.fetchFriends();
    });
    appSocket.onRequests(() async {
      await requestController.fetchRequests();
    });
    super.initState();
  }

  @override
  void dispose() {
    appSocket.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = <Widget>[
    ChatsScreen(),
    FriendsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _appBar(),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages, //New
                ),
              ),
            ],
          ),
        ),
        //extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 50.0,
          backgroundColor: Colors.white,
          selectedItemColor: COLOR_YELLOW,
          unselectedFontSize: 0.0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
              icon: Icon(CupertinoIcons.chat_bubble),
              label: AppLocalizations.of(context).translate('chats'),
            ),
            BottomNavigationBarItem(
              activeIcon: Badge(
                  elevation: 0,
                  animationType: BadgeAnimationType.scale,
                  position: BadgePosition.topEnd(top: 2),
                  badgeColor: Colors.green.shade300,
                  badgeContent: Text(
                    '9',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),
                  ),
                  child: Icon(CupertinoIcons.person_fill)
              ),
              icon: Badge(
                  elevation: 0,
                  animationType: BadgeAnimationType.scale,
                  position: BadgePosition.topEnd(top: 2),
                  badgeColor: Colors.green.shade300,
                  badgeContent: Text(
                    '9',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),
                  ),
                  child: Icon(CupertinoIcons.person)
              ),
              label: AppLocalizations.of(context).translate('friends'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Obx(() => !userController.isLoading.value
        ? ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
        leading: IconButton(
          padding: EdgeInsets.all(0),
          icon: CircleAvatar(
              child: CircleImage(
                width: 70,
                height: 70,
                child: CachedNetworkImage(imageUrl: userController.user.value.image),
                borderWidth: 0,
              )
          ),
          onPressed: () {
            //TODO: Profile
            AppApi().logout(context);
          },
        ),
        title: Text( _selectedIndex == 0
          ? AppLocalizations.of(context).translate('chats') : AppLocalizations.of(context).translate('friends'),
          //? '${userController.user.value.fullName}' : AppLocalizations.of(context).translate('friends'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(_selectedIndex == 1)
                IconButton(
                  icon: Icon(CupertinoIcons.person_add, color: COLOR_MAIN),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AddFriendsScreen()
                    ));
                  },
                ),
              if(_selectedIndex == 1)
                SizedBox(width: 5),
              IconButton(
                icon: Icon(CupertinoIcons.bell, color: COLOR_MAIN),
                onPressed: () async {
                  //TODO: Notifications
                },
              )
            ],
          )
        )
        : ListTile(
          contentPadding: EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
          title: Container(),
        ),
    ) ;
  }

}
