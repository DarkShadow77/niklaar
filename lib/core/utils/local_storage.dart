import 'package:hive_flutter/hive_flutter.dart';

import '../constants/strings.dart';

class LocalStorageHelper {
  static final _myPrefs = Hive.box(Strings.appName);

  //Store and Retrieve the users token
  setUserToken(String token) {
    _myPrefs.put("token", token);
  }

  String getUserToken() {
    return _myPrefs.get("token", defaultValue: "");
  }
}
