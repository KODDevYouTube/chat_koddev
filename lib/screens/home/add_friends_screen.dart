import 'package:chat_koddev/api/rest_api.dart';
import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/controllers/search_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/screens/home/friends/online_screen.dart';
import 'package:chat_koddev/screens/home/friends/requests_screen.dart';
import 'package:chat_koddev/widgets/item/friend_item.dart';
import 'package:chat_koddev/widgets/item/user_item.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendsScreen extends StatefulWidget {
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {

  SearchController searchCnt = Get.find();
  FriendController friendController = Get.find();

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
              onChanged: (value) {
                searchCnt.fetchUsers(searchController.text, true);
              },
            ),
          ),
        ),
        body: Column(
          children: [
             Container(
              child: Obx(() => !searchCnt.isLoading.value
                ? searchCnt.userList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchCnt.userList.length,
                    itemBuilder: (BuildContext context, int index){
                      User user = searchCnt.userList[index];
                      return UserItem(user, text: searchController.text);
                    },
                  )
                : searchController.text.length > 0
                  ? _noresults(false)
                  : _suggestions()
                : searchController.text.length > 0
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : _suggestions()
              )
             )
          ],
        ),
      ),
    );
  }

  Widget _suggestions(){
    bool hasRequests = RequestsScreen().createState().filterRequests().length > 0 ? true : false;
    return Column(
      children: [
        if(hasRequests)
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Added Me',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
        if(hasRequests)
          RequestsScreen(),
        if(!hasRequests)
          _noresults(true)
      ],
    );
  }

  Widget _noresults(add){
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nosearch.png',
              color: add
                ? COLOR_CYAN.withOpacity(0.5)
                : COLOR_YELLOW.withOpacity(0.5),
            ),
            SizedBox(height: 20),
            add
            ? Text('Search to add new Friends')
            : Text('No results')
          ],
        ),
      ),
    );
  }

}
