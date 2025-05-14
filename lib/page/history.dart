import 'package:flutter/material.dart';

class HistoryResults extends StatefulWidget {
  const HistoryResults({super.key});

  @override
  State<HistoryResults> createState() => _HistoryResultsState();
}

class _HistoryResultsState extends State<HistoryResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("History Results"),
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center)),
    );
  }
}
