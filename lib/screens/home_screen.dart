import 'package:chat_koddev/api/app_api.dart';
import 'package:chat_koddev/controllers/user_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/screens/home/messages_screen.dart';
import 'package:chat_koddev/screens/home/friends_screen.dart';
import 'package:chat_koddev/widgets/chat_button.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  UserController userController = Get.put(UserController());

  int _selectedIndex = 0;

  @override
  void initState() {
    userController.fetchMe();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = <Widget>[
    MessagesScreen(),
    FriendsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.person_fill),
            icon: Icon(CupertinoIcons.person),
            label: 'Friends',
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Obx(() => !userController.isLoading.value
        ? ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
        leading: InkWell(
          child: CircleAvatar(
              child: CircleImage(
                width: 70,
                height: 70,
                child: Image.network(userController.user.value.image),
                borderWidth: 0,
              )
          ),
          onTap: () {
            //TODO: Profile
          },
        ),
        title: Text( _selectedIndex == 0
          ? 'Chats' : 'Friends',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        trailing:Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(_selectedIndex == 1)
                TextButton(
                  child: Icon(CupertinoIcons.person_add, color: COLOR_MAIN),
                  onPressed: () {
                    //TODO: Add friends
                    Get.defaultDialog(
                      title: "Session Expired",
                      titlePadding: EdgeInsets.all(15),
                      content: getContent(),
                      barrierDismissible: false,
                      confirm: confirmBtn(),
                      onWillPop: () {
                        return null;
                      }
                    );
                  },
                ),
              TextButton(
                child: Icon(CupertinoIcons.bell, color: COLOR_MAIN),
                onPressed: () {
                  //TODO: Notifications
                },
              )
            ],
          )
        )
        : ListTile(
          contentPadding: EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
          title: Center(child: CircularProgressIndicator()),
        ),
    ) ;
  }

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            "Your session has expired. You will have to log in again to start a new session",
            style: TextStyle(color: COLOR_TEXT_LIGHT),)
        ],
      ),
    );
  }

  Widget confirmBtn() {
    return ChatButton(
      child: Center(
        child: Text('OK',
          style: TextStyle(
            fontSize: 17,
            color: Colors.white
          ),
        ),
      ),
      onClick: () {
        AppApi(context).logout();
      },
    );ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(COLOR_YELLOW),
      ),
      onPressed: () {
        AppApi(context).logout();
      },
      child: Text("OK")
    );
  }

}
