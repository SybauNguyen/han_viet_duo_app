enum QuestionType { reading, meaning, character, fillInTheBlank, radical, typing }

class SentenceToken {
  final String text;
  final String? hanVietReading;
  final String? meaning;
  final bool isBlank;

  const SentenceToken({
    required this.text,
    this.hanVietReading,
    this.meaning,
    this.isBlank = false,
  });
}

class Question {
  final QuestionType type;
  final String prompt;
  final List<String> options;
  final String correctAnswer;
  final String associatedCharacter;
  final List<SentenceToken>? sentenceTokens;
  final String sectionTitle;
  final List<String>? acceptedAnswers;

  const Question({
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.associatedCharacter,
    this.sentenceTokens,
    this.sectionTitle = 'Bài học',
    this.acceptedAnswers,
  });

  // Getters tiện dụng khi hiển thị UI cũ trong lúc chuyển model.
  String get answer => correctAnswer;
  String get character => associatedCharacter;
}
