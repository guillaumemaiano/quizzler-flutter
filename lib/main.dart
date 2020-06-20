import 'package:flutter/material.dart';
import 'game_engine.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> _progressDisplayer = [];
  GameEngine _engine;

  _QuizPageState() {
    _engine = GameEngine(this);
  }

// Display update methods
  void _displayResults() async {
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Résultat:"),
              content: Text(_engine.results()),
              actions: <Widget>[
                FlatButton(
                  child: Text('Recommencer!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
    _progressDisplayer = [];
    setState(() {
      reset();
    });
  }

  void _displayResponse({bool userChoice}) {
    if (_engine.validateResponse(userChoice: userChoice)) {
      _progressDisplayer.add(
        Icon(Icons.check, color: Colors.green),
      );
    } else {
      _progressDisplayer.add(
        Icon(
          Icons.close,
          color: Colors.red,
        ),
      );
    }
  }

  Widget questionBuilder() {
    return Text(
      _engine.currentQuestion(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(child: questionBuilder()),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  //The user picked true.
                  _displayResponse(userChoice: true);
                  // decouple UI update and engine -- though ideally I'd like something more responsive, eg the displayer should display the engine's knowledge at any given time rather than hold what's essentially a secondary KB
                  _engine.storeResponse(userChoice: true);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                setState(() {
                  _displayResponse(userChoice: false);
                  // see above
                  _engine.storeResponse(userChoice: false);
                });
              },
            ),
          ),
        ),
        // score keeper
        Row(children: _progressDisplayer)
      ],
    );
  }

  // Messaging
  void gameEnded() {
    _displayResults();
  }

  void reset() {
    _engine.resetGame();
  }
}
