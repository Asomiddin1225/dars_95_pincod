import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class GameCubit extends Cubit<List<String>> {
  GameCubit() : super([]) {
    _setNewQuestion();
  }

  final Map<String, List<String>> games = {
    "milk": [
      "asset/cow.png",
      "asset/milk.png",
      "asset/butter.png",
      "asset/goat.png",
    ],
    "cake": [
      "asset/cake.png",
      "asset/birthday_cake.png",
      "asset/kit_kat_cake.png",
      "asset/cookies_cake.png",
    ],
    "tree": [
      "assset/tree.png",
      "asset/new_year_tree.png",
      "asset/big_tree.png",
      "asset/little_tree.png",
    ],
    "book": [
      "asset/red_book.png",
      "asset/love_book.png",
      "asset/library.png",
      "asset/fairy_tale.png",
    ],
  };

  final List<Map<String, String>> _questions = [
    {"answer": "milk"},
    {"answer": "cake"},
    {"answer": "tree"},
    {"answer": "book"},
  ];

  late String _currentAnswer;
  late List<String> _currentImages;
  late List<String> _shuffledLetters;

  String get currentAnswer => _currentAnswer;
  List<String> get currentImages => _currentImages;
  List<String> get shuffledLetters => _shuffledLetters;

  void _setNewQuestion() {
    if (_questions.isNotEmpty) {
      final question = _questions.removeAt(0);
      _currentAnswer = question["answer"]!;
      _currentImages = games[_currentAnswer]!;
      _shuffledLetters = _shuffleLetters(_currentAnswer);
      emit([]);
    } else {
      // No more questions left
      emit([]); // You can handle the end of the game here
    }
  }

  List<String> _shuffleLetters(String answer) {
    final random = Random();
    final letters = answer.split('');
    final extraLetters = List.generate(
        4,
        (_) => String.fromCharCode(
            random.nextInt(26) + 97)); // Adding extra random letters
    letters.addAll(extraLetters);
    letters.shuffle();
    return letters;
  }

  void startGame(String answer) {
    _currentAnswer = answer;
    _currentImages = games[_currentAnswer]!;
    _shuffledLetters = _shuffleLetters(_currentAnswer);
    emit([]);
  }

  void addLetter(String letter) {
    if (state.length < _currentAnswer.length) {
      emit(List.from(state)..add(letter));
    }
  }

  void removeLetter(String letter) {
    emit(List.from(state)..remove(letter));
  }

  bool checkAnswer() {
    return state.join().toLowerCase() == _currentAnswer;
  }

  void nextQuestion() {
    _setNewQuestion();
  }

  void reset() {
    emit([]);
    _setNewQuestion();
  }
}
