import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../services/storage_service.dart';

class InputScreen extends StatefulWidget {
  @override
  const InputScreen({super.key});
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  double height = 0;
  double weight = 0;
  String gender = 'male';
  String activity = 'low';
  int age = 18;
  final storage = StorageService();

  void calculateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = UserData(
          height: height,
          weight: weight,
          gender: gender,
          activityLevel: activity,
          age: age);
      final calories = user.calculateCalories();
      storage.saveCalories(calories);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Calories Saved: ${calories.toStringAsFixed(0)}'),
      ));
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Data')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              onSaved: (val) => height = double.parse(val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              onSaved: (val) => weight = double.parse(val!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onSaved: (val) => age = int.parse(val!),
            ),
            DropdownButtonFormField<String>(
              value: gender,
              items: ['male', 'female']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => gender = val!,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            DropdownButtonFormField<String>(
              value: activity,
              items: ['low', 'medium', 'high']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => activity = val!,
              decoration: InputDecoration(labelText: 'Activity Level'),
            ),
            ElevatedButton(
              onPressed: calculateAndSave,
              child: Text('Save & Calculate'),
            )
          ],
        ),
      ),
    );
  }
}
