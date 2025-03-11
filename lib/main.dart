import 'package:flutter/material.dart';
import 'package:somnews_v2/somnews.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SomNews',
      home: SomNews(),
    );
  }
}
