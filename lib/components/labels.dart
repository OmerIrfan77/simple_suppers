import 'package:flutter/material.dart';

enum Difficulty { beginner, intermediate, advanced }

class DifficultyLabel extends StatelessWidget {
  final Difficulty difficultyLevel;

  const DifficultyLabel({super.key, required this.difficultyLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: difficultyLevel == Difficulty.beginner
            ? Colors.green
            : difficultyLevel == Difficulty.intermediate
                ? Colors.yellow[800]
                : Colors.red[900],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Text(
            difficultyLevel == Difficulty.beginner
                ? 'Beginner'
                : difficultyLevel == Difficulty.intermediate
                    ? 'Intermed.'
                    : 'Advanced',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}

enum TimeUnit { minutes, hours }

class TimeLabel extends StatelessWidget {
  final String amount;
  final TimeUnit unit;

  const TimeLabel({super.key, required this.amount, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.purple[600],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Row(
            children: [
              const Icon(Icons.watch_later_outlined,
                  size: 20.0, color: Colors.white),
              const SizedBox(width: 5.0),
              Text(
                amount + (unit == TimeUnit.minutes ? 'm' : 'h'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
