// ignore_for_file: deprecated_member_use

import 'package:adhtp_general_analysis/page/evaluation/adhtp_function/adhtp_general_analysis.dart';
import 'package:adhtp_general_analysis/page/evaluation/dass_21.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const AdhtpGeneralAnalysis(),
                            ),
                          );
                        },
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
                                      'ADHTP General Analysis',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'General analysis related to ADHTP and offers overview and general insights based on certain parameters using Gemini AI',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,

                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF388E3C,
                                  ).withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Dass21(),
                            ),
                          );
                        },
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
                                      'DASS 21',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Standard tool used to measure the severity of a range of emotional states and generate insights using Gemini AI',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,

                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF388E3C,
                                  ).withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
