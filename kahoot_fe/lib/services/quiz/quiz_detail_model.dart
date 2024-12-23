class QuizDetail {
  final int quizId;
  final String title;
  final String description;
  final String creator;
  final String coverImage;
  final String visibility;
  final String category;
  final List<QuestionDetail> questions;

  QuizDetail({
    required this.quizId,
    required this.title,
    required this.description,
    required this.creator,
    required this.coverImage,
    required this.visibility,
    required this.category,
    required this.questions,
  });

  factory QuizDetail.fromJson(Map<String, dynamic> json) {
    var questionList = (json['Questions'] as List)
        .map((item) => QuestionDetail.fromJson(item))
        .toList();

    return QuizDetail(
      quizId: json['quiz_id'],
      title: json['title'],
      description: json['description'] ?? '',
      creator: json['creator'],
      coverImage: json['cover_image'] ?? '',
      visibility: json['visibility'],
      category: json['category'] ?? '',
      questions: questionList,
    );
  }
}

class QuestionDetail {
  final int questionId;
  final int quizId;
  final String questionText;
  final String questionType;
  final String mediaUrl;
  final int timeLimit;
  final int points;
  final List<OptionDetail> options;

  QuestionDetail({
    required this.quizId,
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.mediaUrl,
    required this.timeLimit,
    required this.points,
    required this.options,
  });

  factory QuestionDetail.fromJson(Map<String, dynamic> json) {
    var optionList = (json['Options'] as List)
        .map((item) => OptionDetail.fromJson(item))
        .toList();

    return QuestionDetail(
      questionId: json['question_id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      mediaUrl: json['media_url'] ?? '',
      timeLimit: json['time_limit'],
      points: json['points'],
      quizId: json['quiz_id'],
      options: optionList,
    );
  }
}

class OptionDetail {
  final int optionId;
  final int questionId;
  final String optionText;
  final bool isCorrect;

  OptionDetail({
    required this.optionId,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
  });

  factory OptionDetail.fromJson(Map<String, dynamic> json) {
    return OptionDetail(
      optionId: json['option_id'],
      questionId: json['question_id'],
      optionText: json['option_text'],
      isCorrect: json['is_correct'] ?? false,
    );
  }
}
