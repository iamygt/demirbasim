import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';

import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:demirbasim/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase and Hive initialization
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // Init theme
  await DemirBasimTheme.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomServiceFirebase()),
        Provider(create: (_) => ProductServiceFirebase()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final siyahLogo = 'assets/siyah1.png';
  final beyazLogo = 'assets/beyaz.png'; // sonra eklenecek

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: logoCagir(siyahLogo),
        nextScreen: const SplashScreen(),
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.white,
      ),
    );
  }

  Image logoCagir(String logo) {
    return Image.asset(logo);
  }
}
