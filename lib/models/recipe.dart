class Recipe {
  final int id;
  final String title;
  final String instructions;
  final int difficulty;
  final int time;
  final String budget;
  final int isPublic;
  final int? creatorId;
  final String? shortDescription;
  final int? rating;
  final String? imageLink;

  Recipe(
      {required this.id,
      required this.title,
      required this.instructions,
      required this.difficulty,
      required this.time,
      required this.budget,
      required this.isPublic,
      this.creatorId,
      this.shortDescription,
      this.rating,
      this.imageLink});

  static Recipe transform(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      instructions: json['instructions'],
      difficulty: json['difficulty'],
      time: json['time'],
      budget: json['budget'],
      isPublic: json['is_public'],
      creatorId: json['creator_id'],
      shortDescription: json['short_description'],
      rating: json['rating'],
      imageLink: json['image_link'],
    );
  }
}
