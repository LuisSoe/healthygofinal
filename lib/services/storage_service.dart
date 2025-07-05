import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  Future<void> saveCalories(double calories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_calories', calories);
  }

  Future<double?> getCalories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('daily_calories');
  }

  Future<void> saveIntake(double intake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_intake', intake);
  }

  Future<double> getIntake() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('daily_intake') ?? 0;
  }

  Future<void> saveFoodList(List<Map<String, dynamic>> foodList) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(foodList);
    await prefs.setString('food_list', encoded);
  }

  Future<List<Map<String, dynamic>>> getFoodList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('food_list');
    if (jsonString == null) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

}