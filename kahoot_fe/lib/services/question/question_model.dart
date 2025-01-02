class QuestionDetail {
  final int? questionId;
  final int quizId;
  final String questionText;
  final String questionType;
  final String mediaUrl;
  final int timeLimit;
  final int points;
  final List<OptionDetail>? options;

  QuestionDetail({
    this.questionId,
    required this.quizId,
    required this.questionText,
    required this.questionType,
    required this.mediaUrl,
    required this.timeLimit,
    required this.points,
    this.options,
  });

  // Add toJson method to convert the object to a map
  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'question_text': questionText,
      'question_type': questionType,
      'media_url': mediaUrl,
      'time_limit': timeLimit,
      'points': points,
    };
  }

  factory QuestionDetail.fromJson(Map<String, dynamic> json) {
    var optionList = (json['Options'] != null && json['Options'] is List)
        ? (json['Options'] as List)
            .map((item) => OptionDetail.fromJson(item))
            .toList()
        : [];

    return QuestionDetail(
      questionId: json['question_id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      mediaUrl: json['media_url'] ?? '',
      timeLimit: json['time_limit'],
      points: json['points'],
      quizId: json['quiz_id'],
      options: optionList.cast<OptionDetail>(),
    );
  }
}

class OptionDetail {
  final int? optionId;
  final int questionId;
  final String optionText;
  final bool isCorrect;

  OptionDetail({
    this.optionId,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
  });

  // Add toJson method to convert the option object to a map
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'option_text': optionText,
      'is_correct': isCorrect,
    };
  }

  factory OptionDetail.fromJson(Map<String, dynamic> json) {
    return OptionDetail(
      optionId: json['option_id'],
      questionId: json['question_id'],
      optionText: json['option_text'],
      isCorrect: json['is_correct'] ?? false,
    );
  }

  @override
  String toString() {
    return 'OptionDetail(questionId: $questionId, optionText: $optionText, isCorrect: $isCorrect)';
  }
}

