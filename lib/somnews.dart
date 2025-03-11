import 'package:flutter/material.dart';

class SomNews extends StatelessWidget {
  const SomNews({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewsScreen();
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
      body: Center(child: Text("welcome to this news application")),
    );
  }
}
