class Quiz {
  final int quizId;
  final String title;
  final String description;
  final String creator;
  final String coverImage;
  final String visibility;
  final String category;
  final String createdAt;
  final String updatedAt;

  Quiz({
    required this.quizId,
    required this.title,
    required this.description,
    required this.creator,
    required this.coverImage,
    required this.visibility,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Quiz from a JSON response
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quiz_id'],
      title: json['title'],
      description: json['description'] ?? '',
      creator: json['creator'],
      coverImage: json['cover_image'] ?? '',
      visibility: json['visibility'],
      category: json['category'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'title': title,
      'description': description,
      'creator': creator,
      'cover_image': coverImage,
      'visibility': visibility,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
