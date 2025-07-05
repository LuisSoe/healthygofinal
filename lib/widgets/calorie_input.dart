import 'package:flutter/material.dart';

class CalorieInput extends StatelessWidget {
  final void Function(double) onSubmitted;

  CalorieInput({required this.onSubmitted});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Calories'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            double value = double.tryParse(controller.text) ?? 0;
            onSubmitted(value);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
