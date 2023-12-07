import 'package:flutter/material.dart';
import 'package:simple_suppers/components/labels.dart';

class RecipePreview extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final int difficultyLevel;
  final int time;
  final String? shortDescription;
  final String? imageLink;
  RecipePreview(
      {super.key,
      required this.onTap,
      required this.title,
      required this.difficultyLevel,
      required this.time,
      this.shortDescription,
      this.imageLink});

  @override
  Widget build(BuildContext context) {
    Difficulty difficulty = Difficulty.beginner;
    int timeTaken = time;
    TimeUnit timeUnit = TimeUnit.minutes;
    switch (difficultyLevel) {
      case 1:
        difficulty = Difficulty.beginner;
        break;
      case 2:
        difficulty = Difficulty.intermediate;
        break;
      case 3:
        difficulty = Difficulty.advanced;
        break;
    }

    if (timeTaken > 60) {
      timeTaken = timeTaken ~/ 60;
      timeUnit = TimeUnit.hours;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 249, 219, 206),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 193, 179, 154).withOpacity(0.7),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: [
              Row(
                children: [
                  // Image on the left side
                  Container(
                    width: 140.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                            imageLink ?? 'https://picsum.photos/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 10.0), // Add some space between the image and text

                  // Text on the right side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height:
                                10.0), // Add some space between subtitle and labels
                        Row(
                          children: [
                            DifficultyLabel(difficultyLevel: difficulty),
                            const SizedBox(width: 10.0),
                            TimeLabel(amount: time.toString(), unit: timeUnit),
                          ],
                        ),
                        const SizedBox(
                            height:
                                10.0), // Add some space between title and subtitle
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  shortDescription!,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromRGBO(97, 97, 97, 1),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
