import 'dart:convert';
import 'package:android_component/quiz/question.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:flutter/services.dart';

class QuizReader {
  // Method to parse quiz type from string
  static QuizType parseQuizType(String quizTypeString) {
    switch (quizTypeString) {
      case 'Animal':
        return QuizType.animal;
      case 'Vegetable':
        return QuizType.vegetables;
      case 'Fruit':
        return QuizType.fruits;
      case 'Capital':
        return QuizType.capital;
      case 'Maths':
        return QuizType.maths;
      // Add more cases as needed
      default:
        throw ArgumentError('Invalid quiz type string: $quizTypeString');
    }
  }

  // Method to read quiz data from a JSON file
  static Future<Quiz> readJson(String filePath) async {
    try {
      // Load JSON string from the file
      final jsonString = await rootBundle.loadString(filePath);

      // Decode JSON string into a map
      final jsonMap = json.decode(jsonString);

      // Parse quiz type from JSON map
      final QuizType quizType = parseQuizType(jsonMap['type']);

      // Parse questions from JSON map
      final List<Question> questions = (jsonMap['questions'] as List<dynamic>)
          .map((questionJson) => Question(
                text: questionJson['question'],
                options: List<String>.from(questionJson['options']),
                correctAnswer: int.parse(questionJson['correctAnswer']),
              ))
          .toList();

      // Create and return Quiz object
      return Quiz(type: quizType, questions: questions);
    } catch (e) {
      print('Error reading JSON file: $e');
      // Re-throw the exception for handling at the caller's level
      rethrow;
    }
  }
}
