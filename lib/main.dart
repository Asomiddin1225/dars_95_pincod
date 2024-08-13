import 'package:dars_95/bloc/game_cubit.dart';
import 'package:dars_95/screens/bio_metric_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GameCubit>(
          create: (_) => GameCubit(),
        ),
      ],
      child: MaterialApp(
        home: AuthPage(),
      ),
    );
  }
}
