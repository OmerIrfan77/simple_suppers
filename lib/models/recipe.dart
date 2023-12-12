class Recipe {
  int id;
  String title;
  String instructions;
  int difficulty;
  int time;
  String budget;
  int isPublic;
  int creatorId;
  String shortDescription;
  int rating;
  String imageLink;

  Recipe({
    this.id = 0,
    required this.title,
    required this.instructions,
    required this.difficulty,
    required this.time,
    required this.budget,
    required this.isPublic,
    required this.creatorId,
    required this.shortDescription,
    required this.rating,
    required this.imageLink,
  }) {
    if (instructions.isEmpty ||
        difficulty < 1 ||
        difficulty > 3 ||
        time <= 0 ||
        budget.isEmpty ||
        creatorId <= 0 ||
        title.isEmpty ||
        shortDescription.isEmpty ||
        (isPublic != 0 && isPublic != 1) ||
        rating < 1 ||
        rating > 5 ||
        imageLink.isEmpty) {
      throw const FormatException(
          "One or more properties not fulfilled requirements.");
    }
  }

  // Getters
  int getId() => id;
  String getTitle() => title;
  String getInstructions() => instructions;
  int getDifficulty() => difficulty;
  int getTime() => time;
  String getBudget() => budget;
  int getIsPublic() => isPublic;
  int getCreatorId() => creatorId;
  String getShortDescription() => shortDescription;
  int getRating() => rating;
  String getImageLink() => imageLink;

  // Setters
  void setTitle(String newTitle) {
    title = newTitle;
  }

  void setInstructions(String newInstructions) {
    instructions = newInstructions;
  }

  void setDifficulty(int newDifficulty) {
    difficulty = newDifficulty;
  }

  void setTime(int newTime) {
    time = newTime;
  }

  void setBudget(String newBudget) {
    budget = newBudget;
  }

  void setIsPublic(int newIsPublic) {
    isPublic = newIsPublic;
  }

  void setCreatorId(int newCreatorId) {
    creatorId = newCreatorId;
  }

  void setShortDescription(String newShortDescription) {
    shortDescription = newShortDescription;
  }

  void setRating(int newRating) {
    rating = newRating;
  }

  void setImageLink(String newImageLink) {
    imageLink = newImageLink;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'instructions': instructions,
      'difficulty': difficulty,
      'time': time,
      'budget': budget,
      'is_public': isPublic,
      'creator_id': creatorId,
      'short_description': shortDescription,
      'rating': rating,
      'image_link': imageLink,
    };
  }
}
