import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class TrackerScreen extends StatefulWidget {
  @override
   const TrackerScreen({super.key});
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  double intake = 0;
  double goal = 0;
  final storage = StorageService();

  final TextEditingController foodController = TextEditingController();
  final TextEditingController calController = TextEditingController();

  List<Map<String, dynamic>> foodList = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final cals = await storage.getCalories();
    final i = await storage.getIntake();
    final savedFoods = await storage.getFoodList();
    setState(() {
      goal = cals ?? 0;
      intake = i;
      foodList = savedFoods;
    });
  }

  void addFood() async {
    final name = foodController.text.trim();
    final cal = double.tryParse(calController.text) ?? 0;
    if (name.isEmpty || cal == 0) return;

    final newFood = {'name': name, 'calories': cal};
    setState(() {
      foodList.add(newFood);
      intake += cal;
    });

    await storage.saveIntake(intake);
    await storage.saveFoodList(foodList);

    foodController.clear();
    calController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calorie Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Goal: ${goal.toStringAsFixed(0)} kcal'),
            Text('Current Intake: ${intake.toStringAsFixed(0)} kcal'),
            SizedBox(height: 20),
            TextField(
              controller: foodController,
              decoration: InputDecoration(labelText: 'Food name'),
            ),
            TextField(
              controller: calController,
              decoration: InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addFood,
              child: Text('Add Food'),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, index) {
                  final item = foodList[index];
                  return ListTile(
                    title: Text(item['name']),
                    trailing: Text('${item['calories']} kcal'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
