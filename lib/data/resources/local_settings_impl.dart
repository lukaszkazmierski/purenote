import 'package:notebook/domain/repositories/local_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsImpl implements LocalSettings {
  SharedPreferences _prefs;


  @override
  Future<void> call() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  bool introIsClosed() => _prefs.getBool('introIsClosed') ?? false;

  @override
  void closeIntro() => _prefs.setBool('introIsClosed', true);


}
