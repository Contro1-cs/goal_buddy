import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routine_app/modules/home/screens/bot_nav_bar.dart';
import 'package:routine_app/shared/widgets/custom_colors.dart';
import 'package:routine_app/utils/fierbase_init.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseInit().init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Buddy',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          primary: CustomColor.blue,
          seedColor: CustomColor.blue,
          background: CustomColor.black,
        ),
        useMaterial3: true,
      ),
      home: const BotNavBar(),
    );
  }
}
