import 'package:flutter/material.dart';

class Dass21 extends StatefulWidget {
  const Dass21({super.key});

  @override
  State<Dass21> createState() => _Dass21State();
}

class _Dass21State extends State<Dass21> {
  // Define the questions
  final List<Map<String, String>> _questions = [
    {"id": "q1", "text": "I found it hard to wind down."},
    {"id": "q2", "text": "I was aware of dryness of my mouth."},
    {
      "id": "q3",
      "text": "I couldn’t seem to experience any positive feeling at all.",
    },
    // Add more questions here, up to 21
    // For demonstration, let's add a few more
    {
      "id": "q4",
      "text":
          "I experienced breathing difficulty (e.g. excessively rapid breathing, breathlessness in the absence of physical exertion).",
    },
    {
      "id": "q5",
      "text": "I found it difficult to work up the initiative to do things.",
    },
    {"id": "q6", "text": "I tended to over-react to situations."},
    {"id": "q7", "text": "I experienced trembling (e.g. in the hands)."},
  ];
  late Map<String, double> _answers;

  late PageController _pageController;
  int _currentPage = 0;

  final Map<double, String> _sliderValueToLabel = {
    0.0: "Never",
    1.0: "Sometimes",
    2.0: "Often",
    3.0: "Almost Always",
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize answers with default value 0.0 for each question
    _answers = {for (var question in _questions) question['id']!: 0.0};

    _pageController.addListener(() {
      // Using round() can be more reliable for page updates
      if (_pageController.page?.round() != _currentPage) {
        if (mounted) {
          // Check if the widget is still in the tree
          setState(() {
            _currentPage = _pageController.page!.round();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _submitAnswers() {
    // Handle submission of answers
    print("Submitted Answers: $_answers");
    // You can navigate to a results page or send data to a server here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Answers submitted (check console)")),
    );
    // Example: Navigate to a new screen or pop
    // Navigator.of(context).pop(); // Or push a results screen
  }

  // Helper to build each question page
  Widget _buildQuestionPage(BuildContext context, int index) {
    final question = _questions[index];
    final questionId = question['id']!;
    final questionText = question['text']!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Question ${index + 1} of ${_questions.length}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
            const SizedBox(height: 16),
            Text(
              questionText,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            Slider(
              value: _answers[questionId] ?? 0.0,
              min: 0.0,
              max: 3.0,
              year2023: false,
              divisions: 3,
              label:
                  _sliderValueToLabel[(_answers[questionId] ?? 0.0)] ??
                  (_answers[questionId] ?? 0.0).round().toString(),
              onChanged: (double value) {
                setState(() {
                  _answers[questionId] = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Aligns with slider thumb travel
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    _sliderValueToLabel.entries.map((entry) {
                      return Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              (_answers[questionId] ?? 0.0) == entry.key
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                          fontWeight:
                              (_answers[questionId] ?? 0.0) == entry.key
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const Spacer(), // Pushes navigation buttons to the bottom if they were part of this column
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DASS-21 Questionnaire"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              "Please read each statement and select a number 0, 1, 2, or 3 which indicates how much the statement applied to you over the past week. There are no right or wrong answers. Do not spend too much time on any statement.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              itemBuilder:
                  (context, index) => _buildQuestionPage(context, index),
              onPageChanged: (int page) {
                // It's good to also update here in case listener fires late or during programmatic jumps
                setState(() {
                  _currentPage = page;
                });
              },
              // physics: NeverScrollableScrollPhysics(), // Uncomment to disable swipe gestures
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text("Previous"),
                  )
                else
                  const SizedBox(width: 80), // To keep spacing consistent

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_currentPage < _questions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _submitAnswers();
                    }
                  },
                  child: Text(
                    _currentPage < _questions.length - 1
                        ? "Next"
                        : "Submit Answers",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
