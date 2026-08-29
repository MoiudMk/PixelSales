import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PixelSalesApp());
}

class PixelSalesApp extends StatelessWidget {
  const PixelSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PixelSales',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}