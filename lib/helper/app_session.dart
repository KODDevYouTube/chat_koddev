import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSession {

  FlutterSecureStorage _storage;

  AppSession() {
    _storage = FlutterSecureStorage();
  }

  addSessions({uid, token, login, expiresAt}) async {
    if(uid != null)       await _storage.write(key: "uid", value: uid);
    if(token != null)     await _storage.write(key: "token", value: token);
    if(login != null)     await _storage.write(key: "login", value: login);
    if(expiresAt != null)     await _storage.write(key: "expiresAt", value: expiresAt);
  }

  Future<Map<String, String>> readSessions() async {
    return await _storage.readAll();
  }

}