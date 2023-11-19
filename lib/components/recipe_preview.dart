import 'package:flutter/material.dart';
import 'package:simple_suppers/components/labels.dart';

class RecipePreview extends StatelessWidget {
  final void Function() onTap;
  const RecipePreview({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 10.0), // Add some space between the image and text

                  // Text on the right side
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pizza',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height:
                                10.0), // Add some space between subtitle and labels
                        Row(
                          children: [
                            DifficultyLabel(
                                difficultyLevel: Difficulty.beginner),
                            SizedBox(width: 10.0),
                            TimeLabel(amount: '30', unit: TimeUnit.minutes),
                          ],
                        ),
                        SizedBox(
                            height:
                                10.0), // Add some space between title and subtitle
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  'A short description of the recipe will be over here. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(
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
