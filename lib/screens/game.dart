import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'package:confetti/confetti.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final controller = ConfettiController();
  bool isPlaying = false;

  bool xTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];

  int attempts = 0;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
      textStyle: TextStyle(
    color: Colors.white,
    letterSpacing: 3,
    fontSize: 28,
  ));

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      if (seconds == 0) {
        resultDeclaration = 'Time Up!';
      }
    });
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.state == ConfettiControllerState.playing) {
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            controller.stop();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MainColor.xColor,
                          width: 2,
                        ), //Border.all
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: MainColor.primaryColor,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Player X',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            xScore.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MainColor.oColor,
                          width: 2,
                        ), //Border.all
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: MainColor.primaryColor,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Player O',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            oScore.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 4,
                            color: matchedIndexes.contains(index)
                                ? Colors.yellowAccent
                                : MainColor.primaryColor,
                          ),
                          color: matchedIndexes.contains(index)
                              ? Colors.black
                              : MainColor.secondaryColor,
                        ),
                        child: displayXO[index] == ''
                            ? Text(displayXO[index])
                            : Center(
                                child: displayXO[index] == 'X'
                                    ? Image.asset(
                                        'assets/images/cross.png',
                                        scale: 1.5,
                                      )
                                    : Image.asset(
                                        'assets/images/circle.png',
                                        scale: 1.4,
                                      ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Text(
                      resultDeclaration,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: resultDeclaration == 'Time Up!'
                            ? Colors.red
                            : MainColor.winColor,
                        fontSize: attempts == 0 ? 0 : 30,
                      ),
                    ),
                    SizedBox(height: 30),
                    attempts == 0
                        ? Column(
                            children: [
                              Text(
                                'Welcome to Tic Tac Toe',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MainColor.startButton,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  startTimer();
                                  _clearBoard();
                                  attempts++;
                                },
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : _buildTimer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
      ),
    ]);
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (xTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        } else if (!xTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        }

        xTurn = !xTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // Check 1st Row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 1, 2]);
        _updateScore(displayXO[0]);
      });
    }

    // Check 2nd Row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[3] + ' Wins!';
        matchedIndexes.addAll([3, 4, 5]);
        _updateScore(displayXO[3]);
      });
    }

    // Check 3rd Row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 7, 8]);
        _updateScore(displayXO[6]);
      });
    }

    // Check 1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 3, 6]);
        _updateScore(displayXO[0]);
      });
    }

    // Check 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[1] + ' Wins!';
        matchedIndexes.addAll([1, 4, 7]);
        _updateScore(displayXO[1]);
      });
    }

    // Check 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[2] + ' Wins!';
        matchedIndexes.addAll([2, 5, 8]);
        _updateScore(displayXO[2]);
      });
    }

    // Check diagonal left
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 4, 8]);
        _updateScore(displayXO[0]);
      });
    }

    // Check diagonal right
    if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 4, 2]);
        _updateScore(displayXO[6]);
      });
    }

    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'It\'s a Tie!';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
    controller.play();
    stopTimer();
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      winnerFound = false;
      matchedIndexes = [];
      filledBoxes = 0;
      xTurn = true;
    });
  }

  void _resetScores() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      winnerFound = false;
      matchedIndexes = [];
      filledBoxes = 0;
      xTurn = true;
      attempts = 0;
      xScore = 0;
      oScore = 0;
    });
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 1 - seconds / maxSeconds,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 8,
                      backgroundColor: MainColor.accentColor,
                    ),
                    Center(
                      child: Text(
                        '$seconds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.resetButton,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // <-- Radius
                  ),
                ),
                onPressed: () {
                  _clearBoard();
                  stopTimer();
                },
                child: Text(
                  'Stop',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.resetButton,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // <-- Radius
                  ),
                ),
                onPressed: () {
                  _resetScores();
                },
                child: Text(
                  'Reset Scores',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              // Expanded(child: SizedBox(width: 0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColor.playAgainButton,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // <-- Radius
                  ),
                ),
                onPressed: () {
                  startTimer();
                  _clearBoard();
                  attempts++;
                },
                child: Text(
                  'Play Again!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          );
  }
}
