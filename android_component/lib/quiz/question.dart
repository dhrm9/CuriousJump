// Class representing a quiz question
class Question {
  final String text; // The text of the question
  final List<String> options; // List of options for the question
  final int correctAnswer; // Index of the correct answer in the options list

  // Constructor for the Question class
  Question({
    required this.text, // Required parameter: the text of the question
    required this.options, // Required parameter: list of options
    required this.correctAnswer, // Required parameter: index of the correct answer
  });

  // Method to convert Question object to a map
  Map<String, dynamic> toMap() {
    return {
      'text': text, // Key 'text' with the value of the question text
      'options': options, // Key 'options' with the value of the options list
      'correctAnswer': correctAnswer, // Key 'correctAnswer' with the value of the correct answer index
    };
  }
}
