import 'dart:convert';
import 'package:chat_koddev/api/api.dart';
import 'package:chat_koddev/helper/app_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestApi {

  BuildContext context;

  RestApi({this.context});

  login(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/auth/login', params, onResponse, onError);
  }

  register(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/auth/register', params, onResponse, onError);
  }

  logout({onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/auth/logout', onResponse, onError);
  }

  checkUsername(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/auth/check-username', params, onResponse, onError);
  }

  me({onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/auth/me', onResponse, onError);
  }

  refreshToken({onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/auth/refresh', onResponse, onError);
  }

  chats({onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/private/chats', onResponse, onError);
  }

  friends({onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/private/friends', onResponse, onError);
  }

  searchUsers(text, {onResponse, onError}) async {
    await _makeGetRequest('${Api.HOST}/private/search/$text/users', onResponse, onError);
  }

  addFriend(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/private/friend/add', params, onResponse, onError);
  }

  acceptFriend(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/private/friend/accept', params, onResponse, onError);
  }

  dismissFriend(params, {onResponse, onError}) async {
    await _makePostRequest(true, '${Api.HOST}/private/friend/dismiss', params, onResponse, onError);
  }

  _makePostRequest(contentType, url, params, onResponse, onError) async {
    var res = await http.post(
      Uri.parse(url),
      headers: await headers(contentType),
      body: contentType ? json.encode(params) : params,
    ).catchError((err) {
      onError(err.toString());
    });
    if(res.statusCode == 200){
      try{
        var data = json.decode(res.body);
        if (data['error']) {
          onError(data['message'].toString());
        } else {
          onResponse(data);
        }
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    } else {
      onError('Error ${res.statusCode}');
    }
  }

  _makeGetRequest(url, onResponse, onError) async {
    var res = await http.get(
      Uri.parse(url),
      headers: await headers(true),
    ).catchError((err) {
      onError(err.toString());
    });
    if(res.statusCode == 200){
      try{
        var data = json.decode(res.body);
        if (data['error']) {
          onError(data['message'].toString());
        } else {
          onResponse(data);
        }
      } catch(e){
        onError('${res.statusCode} - ${e.toString()}');
      }
    } else {
      onError('Error ${res.statusCode}');
    }
  }

  _makeMultipartRequest(url, http.MultipartFile value, onResponse, onError) async {
    var res = http.MultipartRequest(
        'POST',
        Uri.parse(url)
    );
    headers(true).then((value) {
      res.headers['Authorization'] = value['Authorization'];
    });
    res.files.add(value);
    var req = await res.send();
    if(req.statusCode == 200){
      onResponse();
    } else {
      onError('Error ${req.statusCode}');
    }
  }

  Future<Map<String, String>> headers(bool contentType) async {
    Map<String, String> session = await AppSession().readSessions();
    String token = session['token'];
    String auth = 'Bearer $token';
    return <String, String>{
      if(contentType)
        "Content-Type": "application/json",
      "Authorization": auth
    };
  }

}