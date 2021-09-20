import 'package:flutter/foundation.dart';

class Api {
  static const HOST = kReleaseMode
      ? 'http://46.99.153.249:5001/api'
      : 'http://192.168.88.28:5001/api';
}