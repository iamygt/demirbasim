import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demirbasim/models/product_model.dart';
import 'package:demirbasim/service/product_service.dart';
import 'package:demirbasim/service/room_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await RoomService().openBox();
  await Hive.openBox<Product>('products');
  // await Firebase.initializeApp();
  await DemirBasimTheme.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomService()),
        Provider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = DemirBasimTheme.themeMode;

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        DemirBasimTheme.saveThemeMode(mode);
      });

  final siyahLogo = 'assets/siyah1.png';
  final beyazLogo = 'assets/beyaz.png'; // sonra eklenecek
  @override
  void dispose() {
    Hive.box('products').close();
    Hive.box('rooms').close();

    super.dispose();
  }

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
}

Image logoCagir(String logo) {
  return Image.asset(
    logo,
  );
}
