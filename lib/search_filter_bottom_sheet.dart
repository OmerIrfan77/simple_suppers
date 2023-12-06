import 'package:flutter/material.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  @override
  _SearchFilterBottomSheetState createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  // Variables to store the selected values
  String selectedDifficulty = '1';
  int selectedTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[850],
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 16.0),
              _buildFilterButton(
                  'Difficulty',
                  ['Beginner', 'Intermediate', 'Advanced'],
                  selectedDifficulty, (value) {
                setState(() {
                  selectedDifficulty = value;
                });
              }),
              const SizedBox(width: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Time (min)',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(130, 115, 104, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(130, 115, 104, 1)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = int.parse(value);
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange[700],
              ),
              onPressed: () {
                // Perform search with selected filters
                // Add your search logic here

                // Close the bottom sheet
                Navigator.pop(context, [selectedTime, selectedDifficulty]);
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, List<String> options,
      String selectedValue, Function(String) onChanged) {
    return Column(
      children: [
        DropdownMenu<String>(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
          initialSelection: 'Beginner',
          label: Text(title, style: const TextStyle(color: Colors.white)),
          onSelected: (value) {
            if (value == 'Advanced') {
              value = '3';
            } else if (value == 'Intermediate') {
              value = '2';
            } else {
              value = '1';
            }
            onChanged(value);
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
