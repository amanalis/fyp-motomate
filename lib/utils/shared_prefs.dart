import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  sharedPrefsInit() async {
    await SharedPreferences.getInstance();
  }

  Future<void> saveUserDataInPrefs(String name, String id, String email,
      String password, String phonenumber, String imageURL, String proaccount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setString("id", id);
    prefs.setString("phonenumber", phonenumber);
    prefs.setString("name", name);
    prefs.setString("imageURL", imageURL);
    prefs.setString("proaccount", proaccount);
  }

  Future<void> updateUserDataInPrefs(
      String name, String password, String phonenumber, String imageURL, String proaccount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("password", password);
    prefs.setString("phonenumber", phonenumber);
    prefs.setString("name", name);
    prefs.setString("imageURL", imageURL);
    prefs.setString("proaccount", proaccount);
  }

  Future<void> rememberMe(bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("rememberMe", rememberMe);
  }

  Future<bool?> isRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("rememberMe");
  }

  Future<void> updateImageURL(String imageURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imageURL", imageURL);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
