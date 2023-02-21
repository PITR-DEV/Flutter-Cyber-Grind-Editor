import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

Future<void> initializePreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class PreferenceProperties {
  static const blackBackground = 'blackBackground';
  static const debugOverlay = 'debugOverlay';
  static const brushTintEnabled = 'brushTintEnabled';
  static const colorCodedPrefabs = 'colorCodedPrefabs';
}
