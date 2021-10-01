import 'package:flutter/foundation.dart';

class Api {
  static const HOST = kReleaseMode
      ? 'http://46.99.153.249:5001/api'
      : 'http://192.168.88.28:5001/api';

  static const SOCKET_SERVER = kReleaseMode
      ? 'http://46.99.153.249:5050'
      : 'http://192.168.88.28:5050';
}