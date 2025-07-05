import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _intake = 0;
  final double _goal = 2000;

  @override
  void initState() {
    super.initState();
    _loadIntake();
  }

  Future<void> _loadIntake() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _intake = prefs.getDouble('daily_intake') ?? 0;
    });
  }

  Future<void> _resetIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_intake', 0);
    setState(() {
      _intake = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double percent = (_intake / _goal).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthyGo'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Kalori Hari Ini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 13.0,
                animation: true,
                percent: percent,
                center: Text(
                  "${_intake.toInt()} / ${_goal.toInt()} kcal",
                  style: const TextStyle(fontSize: 18.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.green,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _resetIntake,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Kalori"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
