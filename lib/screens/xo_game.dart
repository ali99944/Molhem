import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/helpers/theme_helper.dart';

class XOGame extends StatefulWidget {
  const XOGame({super.key});

  @override
  State<XOGame> createState() => _XOGameState();
}

class _XOGameState extends State<XOGame> {
  // Create a 3x3 board
  // Each cell will be represented by a string
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  // Keep track of the current player (a player can be 'X' or 'O')
  String _player = 'X';
  String _result = '';

  // Make a move
  // This function will be called when a player taps on a cell
  void _play(int row, int col) {
    if (_board[row][col] == '') {
      setState(() {
        _board[row][col] = _player;
        _checkWin();
        if (_result == '') {
          _player = _player == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  // Check if there is a winner
  // This function will be called after every move
  void _checkWin() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2] &&
          _board[i][0] != '') {
        _result = 'win_message'.tr(args: [_board[i][0]]);
        return;
      }
      if (_board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[0][i] != '') {
        _result = 'win_message'.tr(args: [_board[0][i]]);
        return;
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _result = 'win_message'.tr(args: [_board[0][0]]);
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _result = 'win_message'.tr(args: [_board[0][2]]);
      return;
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          return;
        }
      }
    }
    _result = 'draw!'.tr();
  }

  // Reset the game
  // This function will be called when the reset button is pressed
  void _reset() {
    setState(() {
      _board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      _player = 'X';
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.autismColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Draw the board
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _play(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                      color: _board[row][col] == 'X'
                          ? Color(0xffffb6c1)
                          : _board[row][col] == 'O'
                              ? Color(0xff9dc7df)
                              : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Display the current player
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'player_turn'.tr(args: [_player]),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Display the result
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _result,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _result == '' ? Colors.transparent : Colors.blue,
              ),
            ),
          ),

          // Reset button
          Container(
            padding: const EdgeInsets.all(20.0),
            height: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff9dc7df),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
              ),
              onPressed: _reset,
              child: const Text(
                'reset',
                style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.black
                ),
              ).tr(),
            ),
          ),
        ],
      ),
    );
  }
}