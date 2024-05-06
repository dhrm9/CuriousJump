import 'package:android_component/quiz/question.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

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

  static Future<void> saveToFirestore(
      String quizType, List<Map<String, dynamic>> questions) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('quizzes').add({
        'type': quizType,
        'questions': questions,
      });
    } catch (e) {
      print('Error saving quiz data to Firestore: $e');
      rethrow;
    }
  }

  static Future<Quiz?> fetchQuizFromFirestore(String quizType) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('quizzes')
          .where('type', isEqualTo: quizType)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No quiz found for type: $quizType');
        return null;
      }

      final List<Question> questions = [];
      final quizData = querySnapshot.docs.first.data();
      final List<dynamic> questionData = quizData['questions'];
      for (var question in questionData) {
        questions.add(Question(
          text: question['text'],
          options: List<String>.from(question['options']),
          correctAnswer: question['correctAnswer'],
        ));
      }
      final parsedQuizType = parseQuizType(quizType);
      return Quiz(type: parsedQuizType, questions: questions);
    } catch (e) {
      print('Error fetching quiz data from Firestore: $e');
      return null;
    }
  }
}
