import 'package:flutter/material.dart';
import 'package:somnews_v2/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> articles = [];
  final String apiKey = '6d926d933e40424b83238351c3e69adb';
  late AnimationController _controller;
  String selectedCategory = 'general';
  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 500),
    );
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() {
      articles = [];
    });
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$selectedCategory&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = List<Map<String, dynamic>>.from(data['articles']);
        _controller.reset();
        _controller.forward();
      });
    } else {
      throw Exception('Masoo Qabsanyo Net ka');
    }
  }

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
      body: Card(child: Text('test')),
    );
  }
}
