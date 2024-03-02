import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routine_app/modules/home/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:routine_app/modules/shared/widgets/colors.dart';
import 'package:routine_app/utils/supabase.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseCred().getUrl(),
    anonKey: SupabaseCred().getAnon(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

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
          seedColor: CustomColor.blue,
          background: CustomColor.black,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}