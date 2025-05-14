import 'package:flutter/material.dart';

class MainQuestionare extends StatefulWidget {
  const MainQuestionare({super.key});

  @override
  State<MainQuestionare> createState() => _MainQuestionareState();
}

class _MainQuestionareState extends State<MainQuestionare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Main ADHTP/Questionare General Analysis"),
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center)),
    );
  }
}
