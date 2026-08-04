import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:almasry_2/firebase_options.dart';

// Runs in its own isolate, so Firebase must be initialized again here.
// Keep it top-level with @pragma('vm:entry-point') or release builds drop it.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
