import 'package:android_component/quiz/question.dart';

enum QuizType { animal , capital , maths , fruits , vegetables}

class Quiz{
  final QuizType type;
  final List<Question> questions;

  Quiz({required this.type , required this.questions});

}