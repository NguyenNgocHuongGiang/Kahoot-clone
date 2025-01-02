class Quiz {
  final int? id;
  final String title;
  final String description;
  final String creator;
  final String coverImage;
  final String visibility;
  final String category;


  Quiz({
    this.id, 
    required this.title,
    required this.description,
    required this.creator,
    required this.coverImage,
    required this.visibility,
    required this.category,
  });

  // Factory constructor to create Quiz from a JSON response
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['quiz_id'],
      title: json['title'],
      description: json['description'] ?? '',
      creator: json['creator'],
      coverImage: json['cover_image'] ?? '',
      visibility: json['visibility'],
      category: json['category'] ?? '',
    );
  }

  // Method to convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'quiz_id': id,
      'title': title,
      'description': description,
      'creator': creator,
      'cover_image': coverImage,
      'visibility': visibility,
      'category': category
    };
  }
}