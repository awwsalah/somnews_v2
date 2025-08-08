import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SomNews'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeConfig.primaryGradient,
          ),
        ),
      ),
      body: const Center(
        child: Text('Home Screen - News will be displayed here.'),
      ),
    );
  }
}
