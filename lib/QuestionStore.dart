import 'questions.dart';

class QuestionStore {

  List<Question> _questions = [
    Question(phrase: 'La Tour de Babel a vraiment existé.', answer: true),
    Question(
        phrase:
        'Le point le plus profond des océans est plus de douze fois plus profond que le plus haut bâtiment humain n\'est haut.',
        answer: true),
    Question(
        phrase: 'Les éléphants ont du mal à descendre les pentes aïgues',
        answer: true),
    Question(
        phrase: 'Certaines araignées dévorent des souris',
        answer: true),
    Question(
        phrase: 'Certaines meutes de loups refusent de manger de la viande pour des raisons philosophiques',
        answer: false),
  ];

  String getPhrase(int questionNumber) {
    // crashes if out of bounds
      return _questions[questionNumber].question;
  }

  bool getExpectation(int questionNumber) {
    // crashes if out of bounds
    return _questions[questionNumber].expect;
  }

  int getSize() {
    return _questions.length;
  }

}