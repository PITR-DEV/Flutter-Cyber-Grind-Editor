import 'package:flutter_riverpod/flutter_riverpod.dart';

class Preferences {
  static final blackBackgroundProvider = StateProvider((ref) => false);
  static final debugOverlay = StateProvider((ref) => false);
}
