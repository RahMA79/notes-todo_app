import 'package:flutter/material.dart';
import 'package:notes_app/Notes&ToDo.dart';
import 'package:notes_app/Notifications.dart';
import 'package:notes_app/SqlDatabase.dart';
import 'package:notes_app/splash%20screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // open the connection between dart layer and flutter engine
  SqlHelper().getDatabase();
  LocalNotificationService.init();
  LocalNotificationService.showScheduledNotification(9, 0);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
