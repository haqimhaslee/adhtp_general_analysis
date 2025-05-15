import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class HistoryResults extends StatefulWidget {
  const HistoryResults({super.key});

  @override
  State<HistoryResults> createState() => _HistoryResultsState();
}

class _HistoryResultsState extends State<HistoryResults> {
  int? _value = 0; // Default to the first chip being selected

  final List<String> _chipLabels = ["ADHTP", "DASS 21"];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> _fetchAdhtpHistory() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('history')
              .where('tag', isEqualTo: 'htp_analysis')
              .get();
      return querySnapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching ADHTP history: $e");
      }
      return [];
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchDassHistory() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('history')
              .where('tag', isEqualTo: 'dass_21')
              .get();
      return querySnapshot.docs;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching ADHTP history: $e");
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Wrap(
                  spacing: 10.0,
                  children:
                      List<Widget>.generate(_chipLabels.length, (int index) {
                        return ChoiceChip(
                          label: Text(_chipLabels[index]),
                          selected: _value == index,

                          onSelected: (bool selected) {
                            setState(() {
                              _value = selected ? index : null;
                            });
                          },
                        );
                      }).toList(),
                ),
              ),

              if (_value == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FutureBuilder<List<QueryDocumentSnapshot>>(
                    future: _fetchAdhtpHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Error: ${snapshot.error}"),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: Text("No ADHTP history found.")),
                        );
                      }

                      List<QueryDocumentSnapshot> documents = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap:
                            true, // Important when ListView is inside another scrollable
                        physics:
                            const NeverScrollableScrollPhysics(), // To prevent nested scrolling issues
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;
                          String docId = documents[index].id;

                          String title =
                              data['title'] ??
                              'General Analysis'; // Fallback title
                          String dateDisplay = 'No date';
                          if (data['timestamp'] != null &&
                              data['timestamp'] is Timestamp) {
                            // import 'package:intl/intl.dart'; // for DateFormat
                            // dateDisplay = DateFormat.yMMMd().add_jm().format((data['timestamp'] as Timestamp).toDate());
                            dateDisplay = (data['timestamp'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 16);
                          } else if (data['date'] != null) {
                            dateDisplay = data['date'].toString();
                          }
                          String summary =
                              data['aiResponse'] ?? 'No summary available.';
                          // --- End customization ---

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 0,
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date: $dateDisplay"),
                                  Text(
                                    "Summary: $summary",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "ID: $docId",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true, // Adjust if needed
                              onTap: () {
                                // Handle tap, e.g., navigate to a detailed view of this history item
                                if (kDebugMode) {
                                  print(
                                    "Tapped on ADHTP item: ${documents[index].id}",
                                  );
                                }
                                // You could pass documents[index].id or data to a new screen
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

              if (_value == 1) // DASS 21 selected
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FutureBuilder<List<QueryDocumentSnapshot>>(
                    future: _fetchDassHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Error: ${snapshot.error}"),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No DASS 21 history found."),
                          ),
                        );
                      }
                      List<QueryDocumentSnapshot> documents = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;
                          String docId = documents[index].id;

                          String title = data['title'] ?? 'DASS 21 Entry';
                          String dateDisplay = 'No date';
                          if (data['timestamp'] != null &&
                              data['timestamp'] is Timestamp) {
                            dateDisplay = (data['timestamp'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 16);
                          } else if (data['date'] != null) {
                            dateDisplay = data['date'].toString();
                          }
                          String summary =
                              data['insight'] ?? 'No summary available.';
                          // --- End customization ---

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date: $dateDisplay"),
                                  Text(
                                    "Summary: $summary",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "ID: $docId",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true, // Adjust if needed
                              onTap: () {
                                // Handle tap, e.g., navigate to a detailed view of this history item
                                if (kDebugMode) {
                                  print(
                                    "Tapped on ADHTP item: ${documents[index].id}",
                                  );
                                }
                                // You could pass documents[index].id or data to a new screen
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

              if (_value == null) // Placeholder when no chip is selected
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text("Select a test type above to see history."),
                  ),
                ),
              const SizedBox(height: 20), // Add some padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
