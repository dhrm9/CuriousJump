import 'package:android_component/models/player_data.dart';
import 'package:android_component/quiz/question.dart';
import 'package:android_component/quiz/quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Database {
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

  // Method to store player data in local storage
  static void storePlayerData(String playerName, Map<String, int> scores) async {
    final box = await Hive.openBox<PlayerData>('playerData');
    final playerData = PlayerData(playerName: playerName, scores: scores);
    box.put(playerName, playerData);
  }

  // Method to get player data from local storage
  static PlayerData getPlayerData(String playerName) {
    final box = Hive.box<PlayerData>('playerData');
    final playerData = box.get(playerName);
    if (playerData == null) {
      // If player data is not found, return default data
      return PlayerData(playerName: playerName, scores: {
        'AnimalEasy': -100,
        'AnimalMedium': -100,
        'AnimalHard': -100,
        'FruitEasy': -100,
        'FruitMedium': -100,
        'FruitHard': -100,
        'MathsEasy': -100,
        'MathsMedium': -100,
        'MathsHard': -100,
        'CapitalEasy': -100,
        'CapitalMedium': -100,
        'CapitalHard': -100,
        'VegetableEasy': -100,
        'VegetableMedium': -100,
        'VegetableHard': -100,
      });
    } else {
      return playerData;
    }
  }

  // Method to save quiz data to Firestore
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

  // Method to fetch quiz data from Firestore
  static Future<Quiz> fetchQuizFromFirestore(
      String quizType, String quizLevel) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('quizzes')
          .where('type', isEqualTo: quizType)
          .where('level', isEqualTo: quizLevel)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No quiz found for type: $quizType');
        return Quiz(type: QuizType.animal, questions: []);
      }

      final List<Question> questions = [];
      final quizData = querySnapshot.docs.first.data();
      final List<dynamic> questionData = quizData['questions'];
      for (var question in questionData) {
        questions.add(Question(
          text: question['text'],
          options: List<String>.from(question['options']),
          correctAnswer: int.parse(question['correctAnswer']),
        ));
      }
      final parsedQuizType = parseQuizType(quizType);
      return Quiz(type: parsedQuizType, questions: questions);
    } catch (e) {
      print('Error fetching quiz data from Firestore: $e');
      return Quiz(type: QuizType.animal, questions: []);
    }
  }
}
