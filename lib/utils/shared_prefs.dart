import 'package:shared_preferences/shared_preferences.dart';

class Shared_Prefs{

  SharedPrefsInit() async{
    await SharedPreferences.getInstance();
  }
  void saveUserDataInPrefs (String name,String id,String email,String password,String phonenumber) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setString("id", id);
    prefs.setString("phonenumber", phonenumber);
    prefs.setString("name", name);
  }

  Future<String?> getData (String key) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}