import 'package:shared_preferences/shared_preferences.dart';

class DataStore {

  static const String LANG_KEY = 'lang_key';

  /// Initialization the singleton dataStore
  ///
  factory DataStore() {
    return _dataStore;
  }
  DataStore._internal() {
    getLang();
  }
  static final DataStore _dataStore = DataStore._internal();
  static DataStore get instance => _dataStore;
  /* */

  String _lang;
  String get lang => _lang;

  Future<bool> setLang(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = value;
    return prefs.setString(LANG_KEY, value);
  }

  Future<String> getLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(LANG_KEY);
    return _lang;
  }
}
