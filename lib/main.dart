import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/cart_service.dart';
import 'services/session_service.dart';
import 'views/login_page.dart';
import 'views/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk keranjang belanja
  await Hive.initFlutter();
  await Hive.openBox(CartService.boxName);

  // Periksa status login sebelumnya
  final bool isLoggedIn = await SessionService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF2E7D32);

    return MaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          primary: brandColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
