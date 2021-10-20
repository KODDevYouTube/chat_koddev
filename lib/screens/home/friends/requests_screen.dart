import 'package:chat_koddev/app_localizations.dart';
import 'package:chat_koddev/controllers/request_controller.dart';
import 'package:chat_koddev/helper/app_progress_dialog.dart';
import 'package:chat_koddev/helper/colors.dart';
import 'package:chat_koddev/models/friend.dart';
import 'package:chat_koddev/models/request.dart';
import 'package:chat_koddev/widgets/item/request_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  RequestController requestController = Get.find();
  AppProgressDialog appProgressDialog;

  @override
  void initState() {
    requestController.getRequests();
    appProgressDialog = AppProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() =>
      !requestController.isLoading.value
          ? requestController.requestList.length > 0
            ? ListView.builder(
              shrinkWrap: true,
              itemCount: requestController.requestList.length,
              itemBuilder: (BuildContext context, int index){
                Request friend = requestController.requestList[index];
                return RequestItem(friend, appProgressDialog);
              },
            )
            : _emptyRequests()
          : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _emptyRequests(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              height: 100,
              child: Image.asset('assets/images/emptyrequests.png'),
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              AppLocalizations.of(context).translate('no_requests'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: COLOR_TEXT_LIGHT
              ),
            ),
          ),
        ],
      ),
    );
  }

}
