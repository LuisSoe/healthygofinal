import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _intake = 0;
  double _goal = 2000;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final intake = prefs.getDouble('daily_intake') ?? 0;
    final goal = prefs.getDouble('daily_goal') ?? 2000;

    setState(() {
      _intake = intake;
      _goal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_intake / _goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text("Beranda")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kalori Harianmu",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 100,
                lineWidth: 14,
                percent: progress,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_intake.toStringAsFixed(0)} / ${_goal.toStringAsFixed(0)} kcal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _loadProgress,
                icon: const Icon(Icons.refresh),
                label: const Text("Perbarui"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
