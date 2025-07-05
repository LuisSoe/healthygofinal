class UserData {
  final double height;
  final double weight;
  final String gender;
  final String activityLevel;
  final int age;

  UserData({
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.age,
  });

  double calculateCalories() {
    double bmr = gender == 'male'
        ? 10 * weight + 6.25 * height - 5 * age + 5
        : 10 * weight + 6.25 * height - 5 * age - 161;

    double multiplier = {
      'low': 1.2,
      'medium': 1.55,
      'high': 1.9
    }[activityLevel] ?? 1.2;

    return bmr * multiplier;
  }
}