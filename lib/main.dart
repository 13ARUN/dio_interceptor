import 'package:flutter/material.dart';

import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Dio Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService _apiService = ApiService();
  String result = 'Press button to test API';

  Future<void> _testApi() async {
    try {
      final users = await _apiService.getUsers();
      setState(() {
        result = 'GET Users: ${users['data'].length} users fetched\n';
      });

      final newUser = await _apiService.createUser('John Doe', 'Developer');
      setState(() {
        result += 'POST Result: User ${newUser['name']} created';
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Dio Interceptor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(result),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testApi,
              child: const Text('Test API Calls'),
            ),
          ],
        ),
      ),
    );
  }
}
