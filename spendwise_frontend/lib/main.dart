import 'package:flutter/material.dart';
import 'core/api/api_client.dart';

void main() { // entry point and we're saying to run the app
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key}); //constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient api = ApiClient(); // object creation

  String status = "Connecting to backend..."; 

  @override
  void initState() {
    super.initState();
    _checkHealth();
  }

  Future<void> _checkHealth() async {
    try {
      final response = await api.getHealth();// calling the function from api_client

      setState(() {
        status = response["status"] as String; // taking the value of the response["status"] and we're saying that it is string and set it as the status
      });
    } catch (e) {
      setState(() {
        status = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpendWise"),
      ),
      body: Center(
        child: Text(
          status,//variable
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}