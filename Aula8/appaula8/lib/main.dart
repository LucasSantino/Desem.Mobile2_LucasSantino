import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/checkout.dart';

void main() {
  runApp(const SmHotelApp());
}

class SmHotelApp extends StatelessWidget {
  const SmHotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        title: 'S&M Hotel',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/login',
        routes: {
          '/': (_) => const Home(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/checkout': (_) => const CheckoutScreen(),
        },
      ),
    );
  }
}
