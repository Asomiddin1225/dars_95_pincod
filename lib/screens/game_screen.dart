
import 'package:dars_95/bloc/game_cubit.dart';
import 'package:dars_95/widgets/pictures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatelessWidget {
  final VoidCallback setupBiometrics;

  GameScreen({required this.setupBiometrics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4 Pics 1 Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<GameCubit, List<String>>(
                builder: (context, state) {
                  return Pictures(
                      images: context.read<GameCubit>().currentImages);
                },
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<GameCubit, List<String>>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return DragTarget<String>(
                      onAccept: (data) {
                        context.read<GameCubit>().addLetter(data);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(4),
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              index < state.length ? state[index] : '',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<GameCubit, List<String>>(
              builder: (context, state) {
                final shuffledLetters =
                    context.read<GameCubit>().shuffledLetters;
                return Wrap(
                  spacing: 10,
                  children: shuffledLetters.map((letter) {
                    return Draggable<String>(
                      data: letter,
                      feedback: Material(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.orange,
                          child: Center(
                            child: Text(
                              letter,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(''),
                        ),
                      ),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const ValueKey("CheckAnswerButton"),
              onPressed: () {
                if (context.read<GameCubit>().checkAnswer()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Correct!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Try again!')),
                  );
                }
              },
              child: const Text('Check Answer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              key: const ValueKey("NextQuestionButton"),
              onPressed: () {
                context.read<GameCubit>().nextQuestion();
              },
              child: const Text('Next Question'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              key: const ValueKey("ResetButton"),
              onPressed: () {
                context.read<GameCubit>().reset();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
