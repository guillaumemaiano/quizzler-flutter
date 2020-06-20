class Question {
  String question;
  bool expect;

  Question({String phrase, bool answer}) {
    question = phrase;
    expect = answer;
  }
}