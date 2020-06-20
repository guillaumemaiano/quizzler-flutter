import 'package:quizzler/QuestionStore.dart';
import 'dart:math';

class GameEngine {
  // NextQuestion, currentQuestion, Correct/wrong, game status
// GameEngine(this.property) // <- cool syntactic sugar
// rflutter_alert 1.0.3 // useful package. Maybe useful?

  var _store = QuestionStore();
  List<String> _currentScoreArray = [];
  int _current = 0;
  int _floor = 60;
  var _uiState;

  GameEngine(this._uiState);

  String currentQuestion() {
    return _store.getPhrase(_current);
  }

  // Displayed as a sequence of 1s and 0s
  String currentScore() {
    _currentScoreArray.reduce((current, next) => "$current$next");
  }

  bool computeResult() {
    return computePercentage() >= _floor;
  }

  int computePercentage() {
    int score = 0;
    _currentScoreArray.forEach((element) {
      if (element == "0") {
        score++;
      }
    });
    return (score * 100 / _store.getSize()).ceil();
  }

  String results() {
    if (_currentScoreArray.length == _store.getSize()) {
      String resultWord = computeResult() ? "victoire" : "défaite";
      var percents = computePercentage();
      return "C'est une $resultWord, avec $percents% de bonnes réponses.";
    } else {
      return "Programmer error";
    }
  }

  void resetGame() {
    // reset
    _current = 0;
    _currentScoreArray = [];
  }

  void nextQuestion() {
    var next = _current + 1;
    if (next >= _store.getSize()) {
      // feedback
     _uiState.gameEnded();
    } else {
      _current = next;
    }
  }

  void storeResponse({bool userChoice}) {
    if (validateResponse(userChoice: userChoice)) {
      _currentScoreArray.add("0");
    } else {
      _currentScoreArray.add("1");
    }
    print("Array score is now " + _currentScoreArray.toString());
    nextQuestion();
  }

  bool validateResponse({bool userChoice}) {
    //var q = store.getPhrase(current);
    var exp = _store.getExpectation(_current);
    //print("Question: $q, expected: $exp, userpick: $userChoice"  );
    return userChoice == exp;
  }
}
