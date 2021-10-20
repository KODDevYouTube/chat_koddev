import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/request_controller.dart';
import 'package:chat_koddev/controllers/search_controller.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/user.dart';
import 'package:chat_koddev/screens/home/friends/requests_screen.dart';
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

  RequestController requestController = Get.find();
  SearchController searchCnt = Get.find();

  var searchController = new TextEditingController();

  AppProgressDialog appProgressDialog;

  @override
  void initState() {
    searchCnt.clear();
    appProgressDialog = AppProgressDialog(context);
    super.initState();
  }

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
                  hintText: '${AppLocalizations.of(context).translate('search')}',
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
                      return UserItem(user, appProgressDialog, text: searchController.text);
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
    bool hasRequests = requestController.requestList.length > 0 ? true : false;
    return Column(
      children: [
        if(hasRequests)
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).translate('added_me'),
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
            Image.asset(add
              ? 'assets/images/adduser.png'
              : 'assets/images/nosearch.png',
              color: add
                ? COLOR_CYAN.withOpacity(0.5)
                : COLOR_YELLOW.withOpacity(0.5),
            ),
            SizedBox(height: 20),
            add
            ? Text(AppLocalizations.of(context).translate('search_new_friends'))
            : Text(AppLocalizations.of(context).translate('no_results'))
          ],
        ),
      ),
    );
  }

}
