import 'package:android_component/models/question.dart';

// Enum representing different types of quizzes
enum QuizType { animal, capital, maths, fruits, vegetables }

// Enum representing different levels of quiz difficulty
enum QuizLevel { easy, medium, hard }

// Class representing a quiz
class Quiz {
  final QuizType type; // Type of the quiz
  final List<Question> questions; // List of questions in the quiz

  // Constructor for Quiz class
  Quiz({required this.type, required this.questions});

  // Method to convert questions to a list of maps
  List<Map<String, dynamic>> questionsToMapList() {
    return questions.map((question) => question.toMap()).toList();
  }

  // Method to parse quiz level to string
  static String parseQuizLevel(QuizLevel level) {
    String str = "";
    switch (level) {
      case QuizLevel.easy:
        str = "Easy";
        break;
      case QuizLevel.medium:
        str = "Medium";
        break;
      case QuizLevel.hard:
        str = "Hard";
        break;
      default:
        break;
    }
    return str;
  }

  // Method to parse quiz type to string
  static String parseQuizType(QuizType type) {
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
