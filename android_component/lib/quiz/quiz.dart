import 'package:android_component/quiz/question.dart';

enum QuizType { animal, capital, maths, fruits, vegetables }

enum QuizLevel { easy, medium, hard }

class Quiz {
  final QuizType type;
  final List<Question> questions;

  Quiz({required this.type, required this.questions});

  List<Map<String, dynamic>> questionsToMapList() {
    return questions.map((question) => question.toMap()).toList();
  }

  static String getQuizType(QuizType type) {
    String str = "";
    switch (type) {
      case QuizType.animal:
        str = "Animal";
        break;
      case QuizType.vegetables:
        str = "Vegetable";
        break;
      case QuizType.fruits:
        str = "Fruit";
        break;
      case QuizType.maths:
        str = "Maths";
        break;
      case QuizType.capital:
        str = "Capital";
        break;
      default:
        break;
    }
    return str;
  }
}
