import 'package:flutter/material.dart';
import 'package:somnews_v2/splashscreen.dart';

class SomNews extends StatelessWidget {
  const SomNews({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SomNews',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(
          'assets/images/somnews2.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
