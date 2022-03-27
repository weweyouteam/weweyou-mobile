import 'package:shared_preferences/shared_preferences.dart';

Future<void> setPrefUserId(String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("USER_PREF", user);
}

Future<String> getPrefUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("USER_PREF") ?? "no user";
}

setFirstData(bool first) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("FIRST", first);
}

Future<bool> getFirstData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("FIRST") ?? true;
}