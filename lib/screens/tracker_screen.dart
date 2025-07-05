import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  List<Map<String, dynamic>> _foodList = [];
  double _totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('food_list');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      _foodList = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    _totalCalories = prefs.getDouble('daily_intake') ?? 0;
    setState(() {});
  }

  Future<void> _addFood() async {
    final name = _foodController.text.trim();
    final cal = double.tryParse(_calorieController.text.trim());

    if (name.isEmpty || cal == null || cal <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    _foodList.add({
      'name': name,
      'calories': cal,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _totalCalories += cal;

    await prefs.setString('food_list', jsonEncode(_foodList));
    await prefs.setDouble('daily_intake', _totalCalories);

    _foodController.clear();
    _calorieController.clear();
    setState(() {});
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('food_list');
    await prefs.setDouble('daily_intake', 0);
    _foodList.clear();
    _totalCalories = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Total Kalori: ${_totalCalories.toStringAsFixed(0)} kcal",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(labelText: "Nama Makanan"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kalori"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addFood,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Makanan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _foodList.isEmpty
                  ? const Center(child: Text("Belum ada makanan."))
                  : ListView.builder(
                      itemCount: _foodList.length,
                      itemBuilder: (context, index) {
                        final item = _foodList[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['name']),
                            trailing: Text("${item['calories']} kcal"),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _clearData,
              icon: const Icon(Icons.delete),
              label: const Text("Reset Semua"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
