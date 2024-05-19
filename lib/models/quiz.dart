class Quiz {
  final String id;
  final String topicId;
  final List<Question> questions;

  Quiz({required this.id, required this.topicId, required this.questions});
}

class Question {
  final String question;
  final List<String> options;
  final int correctOption;

  Question({required this.question, required this.options, required this.correctOption});
}
