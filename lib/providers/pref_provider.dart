import 'package:cgef/services/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Preferences {
  static final blackBackgroundProvider = StateProvider(
      (ref) => prefs.getBool(PreferenceProperties.blackBackground) ?? false);
  static final debugOverlay = StateProvider(
      (ref) => prefs.getBool(PreferenceProperties.debugOverlay) ?? false);
  static final brushTintEnabled = StateProvider(
      (ref) => prefs.getBool(PreferenceProperties.brushTintEnabled) ?? true);
  static final colorCodedPrefabs = StateProvider(
      (ref) => prefs.getBool(PreferenceProperties.colorCodedPrefabs) ?? true);
}
