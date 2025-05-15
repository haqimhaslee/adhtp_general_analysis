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
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 5.0),
                              Text(
                                "History 1",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 17.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "History 1",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  //fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
