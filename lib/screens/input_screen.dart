import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _gender = 'male';
  String _activity = 'sedentary';
  double? _calorieGoal;

  final Map<String, double> _activityFactor = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very_active': 1.9,
  };

  Future<void> _calculateAndSave() async {
    final age = int.tryParse(_ageController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (age <= 0 || height <= 0 || weight <= 0) return;

    double bmr;
    if (_gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    final factor = _activityFactor[_activity] ?? 1.2;
    final goal = bmr * factor;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_goal', goal);

    setState(() {
      _calorieGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Diri")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Umur (tahun)'),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tinggi (cm)'),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Berat (kg)'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Gender: "),
                Expanded(
                  child: DropdownButton<String>(
                    value: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Pria')),
                      DropdownMenuItem(value: 'female', child: Text('Wanita')),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Aktivitas: "),
                Expanded(
                  child: DropdownButton<String>(
                    value: _activity,
                    onChanged: (val) => setState(() => _activity = val!),
                    items: const [
                      DropdownMenuItem(value: 'sedentary', child: Text('Duduk terus')),
                      DropdownMenuItem(value: 'light', child: Text('Ringan')),
                      DropdownMenuItem(value: 'moderate', child: Text('Sedang')),
                      DropdownMenuItem(value: 'active', child: Text('Aktif')),
                      DropdownMenuItem(value: 'very_active', child: Text('Sangat aktif')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAndSave,
              child: const Text("Hitung Kalori Ideal"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            if (_calorieGoal != null) ...[
              const SizedBox(height: 20),
              Text(
                "Kalori ideal harianmu: ${_calorieGoal!.toStringAsFixed(0)} kcal",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ]
          ],
        ),
      ),
    );
  }
}
