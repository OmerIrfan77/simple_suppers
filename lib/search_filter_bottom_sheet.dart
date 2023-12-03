import 'package:flutter/material.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  @override
  _SearchFilterBottomSheetState createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  // Variables to store the selected values
  String selectedDifficulty = 'Any';
  String selectedBudget = 'Any';
  String selectedTime = 'Any';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.orange[700],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Search Filter',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(height: 16.0),
            _buildFilterButton('Difficulty', ['Any', 'Easy', 'Medium', 'Hard'],
                selectedDifficulty, (value) {
              setState(() {
                selectedDifficulty = value;
              });
            }),
            const SizedBox(width: 20),
            _buildFilterButton(
                'Budget', ['Any', 'Low', 'Medium', 'High'], selectedBudget,
                (value) {
              setState(() {
                selectedBudget = value;
              });
            }),
            const SizedBox(width: 20),
            _buildFilterButton(
                'Time', ['Any', 'Short', 'Medium', 'Long'], selectedTime,
                (value) {
              setState(() {
                selectedTime = value;
              });
            }),
          ]),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Perform search with selected filters
              // Add your search logic here

              // Close the bottom sheet
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, List<String> options,
      String selectedValue, Function(String) onChanged) {
    return Column(
      children: [
        DropdownMenu<String>(
          width: 100,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
          initialSelection: 'Any',
          label: Text(title, style: const TextStyle(color: Colors.white)),
          onSelected: (value) {
            onChanged(value!);
          },
          dropdownMenuEntries: options.map((option) {
            return DropdownMenuEntry<String>(
              value: option,
              label: option,
            );
          }).toList(),
        ),
      ],
    );
  }
}
