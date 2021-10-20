import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/friend_controller.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/screens/home/add_friends_screen.dart';
import 'package:chat_koddev/widgets/circle_image.dart';
import 'package:chat_koddev/widgets/item/friend_item.dart';
import 'package:chat_koddev/widgets/item/user_item.dart';
import 'package:chat_koddev/widgets/session_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:get/get.dart';

class NewMessageScreen extends StatefulWidget {
  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {

  FriendController friendController = Get.find();

  List<Friend> friends = [];
  List<Friend> searchFriends = [];

  var searchController = new TextEditingController();

  SearchBar searchBar;

  @override
  void initState() {
    friends = friendController.friendList;
    searchFriends = friends;
    WidgetsBinding.instance.addPostFrameCallback((_){
      friends.sort((a, b) => a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase()));
      setState(() {
        searchFriends = friends;
      });
    });
    super.initState();
  }

  List<Friend> _searchFriends(value){
    List<Friend> list = List();
    friends.forEach((element) {
      if(element.username.toString().toLowerCase().contains(value.toString().toLowerCase())
          || element.firstname.toString().toLowerCase().contains(value.toString().toLowerCase())
          || element.lastname.toString().toLowerCase().contains(value.toString().toLowerCase())){
        list.add(element);
      }
    });
    return list;
  }


  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(AppLocalizations.of(context).translate('new_message')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: COLOR_MAIN, //change your color here
        ),
        actions: [searchBar.getSearchAction(context)]
    );
  }

  _NewMessageScreenState() {
    searchBar = new SearchBar(
        controller: searchController,
        inBar: false,
        showClearButton: false,
        setState: setState,
        onChanged: (value) {
          setState(() {
            searchFriends = _searchFriends(value);
          });
        },
        onClosed: (){
          searchFriends = friends;
        },
        buildDefaultAppBar: buildAppBar
    );
  }

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: Scaffold(
        appBar: searchBar.build(context),
        body: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          leading: CircleImage(
                            child: Icon(Icons.supervisor_account_rounded, color: COLOR_YELLOW),
                            borderWidth: 0,
                            width: 40,
                            height: 40,
                            borderColor: Colors.black12,
                            backgroundColor: Colors.white,
                          ),
                          title: Text('New group'),
                          onTap: () {

                          },
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                          leading: CircleImage(
                            child: Icon(Icons.person_add_alt_1_rounded, color: COLOR_YELLOW, size: 21),
                            borderWidth: 0,
                            width: 40,
                            height: 40,
                            borderColor: Colors.black12,
                            backgroundColor: Colors.white,
                          ),
                          title: Text('New friend'),
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => AddFriendsScreen()
                            ));
                          },
                        ),
                      ),
                      if(friends.length > 0)
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                        title: Text(
                          'Friends',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: COLOR_TEXT_LIGHT
                          ),
                        ),
                      )
                    ])
                )
              ];
            },
          body: searchFriends.length > 0
            ? ListView.builder(
              itemCount: searchFriends.length,
              itemBuilder: (BuildContext context, int index){
                Friend friend = searchFriends[index];
                return FriendItem(friend);
              },
            )
            : searchController.text.length > 0
            ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No results found for \'${searchController.text}\'',
                  textAlign: TextAlign.center,
                ),
              )
            )
            : Container()
        ),
      ),
    );
  }
}
