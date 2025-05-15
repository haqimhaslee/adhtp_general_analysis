import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added for Firestore

// --- Vertex AI Helper Function ---
Future<String?> getVertexInsights(
  int depressionScore,
  String depressionSeverity,
  int anxietyScore,
  String anxietySeverity,
  int stressScore,
  String stressSeverity,
) async {
  try {
    final modelName = 'gemini-2.5-flash-preview-04-17';
    final location = 'us-central1';

    final generationConfig = GenerationConfig(
      maxOutputTokens: 8192,
      temperature: 0.7,
      topP: 0.95,
    );
    // Corrected SafetySetting constructor and HarmBlockThreshold value
    final safetySettings = [
      SafetySetting(
        HarmCategory.hateSpeech,
        HarmBlockThreshold.high,
        HarmBlockMethod.unspecified,
      ),
      SafetySetting(
        HarmCategory.dangerousContent,
        HarmBlockThreshold.high,
        HarmBlockMethod.unspecified,
      ),
      SafetySetting(
        HarmCategory.sexuallyExplicit,
        HarmBlockThreshold.high,
        HarmBlockMethod.unspecified,
      ),
      SafetySetting(
        HarmCategory.harassment,
        HarmBlockThreshold.high,
        HarmBlockMethod.unspecified,
      ),
    ];

    final model = FirebaseVertexAI.instanceFor(
      location: location,
    ).generativeModel(
      model: modelName,
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );

    final prompt = """
You are a helpful AI assistant providing insights based on DASS-21 scores.
The DASS-21 is a self-report questionnaire designed to measure the three related negative emotional states of Depression, Anxiety, and Stress.
The scores provided are scaled (multiplied by 2 from raw scores). The maximum score for each category is 42.
The severity levels (e.g., Normal, Mild, Moderate, Severe, Extremely Severe) are standard interpretations of these scores.

The user's DASS-21 scores are:
- Depression: $depressionScore (Severity: $depressionSeverity)
- Anxiety: $anxietyScore (Severity: $anxietySeverity)
- Stress: $stressScore (Severity: $stressSeverity)

Please provide some general insights based on these scores.
Structure your response clearly.
1.  Start with a brief, empathetic overall observation based on the scores.
2.  For each category (Depression, Anxiety, Stress) where the severity is NOT 'Normal', provide 1-2 actionable, non-medical suggestions or coping strategies relevant to that area.
3.  If all scores are in the 'Normal' range, acknowledge this positively and perhaps offer one general tip for maintaining mental well-being.
4.  Conclude with a reminder that these insights are for informational purposes only, not a substitute for professional medical advice, diagnosis, or treatment. If the user has concerns, they should consult a qualified healthcare provider.

Keep the language supportive and easy to understand. Aim for a response of about 150-300 words.
Do not make definitive statements like "you are suffering from..." but rather "scores at this level may suggest..." or "individuals with similar scores might find it helpful to...".
Use bullet points for suggestions to make them easy to read.
""";

    final content = Content.text(prompt);
    final response = await model.generateContent([content]);

    if (kDebugMode) {
      print("Vertex AI Prompt:\n$prompt");
      print("Vertex AI Response: ${response.text}");
    }
    return response.text;
  } catch (e) {
    if (kDebugMode) {
      print("Error generating content from Vertex AI: $e");
    }
    String errorMessage = "Error: Could not generate insights at this time. ";
    // Corrected to GenerativeAIException
    if (e is VertexAIException) {
      errorMessage += "Details: ${e.message}";
    } else {
      errorMessage += "Please try again later.";
    }
    return errorMessage;
  }
}

class Dass21 extends StatefulWidget {
  const Dass21({super.key});

  @override
  State<Dass21> createState() => _Dass21State();
}

class _Dass21State extends State<Dass21> {
  final List<Map<String, String>> _questions = [
    {"id": "q1", "text": "I found it hard to wind down."},
    {"id": "q2", "text": "I was aware of dryness of my mouth."},
    {
      "id": "q3",
      "text": "I couldn’t seem to experience any positive feeling at all.",
    },
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
    {"id": "q8", "text": "I felt that I was using a lot of nervous energy."},
    {
      "id": "q9",
      "text":
          "I was worried about situationsin which I might panic and make a fool of myself.",
    },
    {"id": "q10", "text": "I felt that I had nothing to look forward to."},
    {"id": "q11", "text": "I found myself getting agitated."},
    {"id": "q12", "text": "I found it difficult to relax."},
    {"id": "q13", "text": "I felt down-hearted and blue ."},
    {
      "id": "q14",
      "text":
          "I was intolerant of anything that kept me from getting on with what I was doing.",
    },
    {"id": "q15", "text": "I felt I was close to panic ."},
    {
      "id": "q16",
      "text": "I was unable to become enthusiastic about anything.",
    },
    {"id": "q17", "text": "I felt I wasn’t worth much as a person."},
    {"id": "q18", "text": "I felt that I was rather touchy."},
    {
      "id": "q19",
      "text":
          "I was aware of the action of my heart in the absence of physicalexertion (eg, sense of heart rate increase, heart missing a beat).",
    },
    {"id": "q20", "text": "I felt scared without any good reason."},
    {"id": "q21", "text": "I felt that life was meaningless."},
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

  final Map<String, List<String>> _dassCategories = {
    "Depression": ["q3", "q5", "q10", "q13", "q16", "q17", "q21"],
    "Anxiety": ["q2", "q4", "q7", "q9", "q15", "q19", "q20"],
    "Stress": ["q1", "q6", "q8", "q11", "q12", "q14", "q18"],
  };

  bool _showResults = false;
  int _depressionScore = -1;
  int _anxietyScore = -1;
  int _stressScore = -1;

  String? _generatedInsight;
  bool _isGeneratingInsight = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _answers = {for (var question in _questions) question['id']!: 0.0};
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        if (mounted) {
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

  void _calculateAndShowResults() {
    int depressionSum = 0;
    int anxietySum = 0;
    int stressSum = 0;

    for (String qId in _dassCategories["Depression"]!) {
      depressionSum += (_answers[qId] ?? 0.0).toInt();
    }
    for (String qId in _dassCategories["Anxiety"]!) {
      anxietySum += (_answers[qId] ?? 0.0).toInt();
    }
    for (String qId in _dassCategories["Stress"]!) {
      stressSum += (_answers[qId] ?? 0.0).toInt();
    }

    _depressionScore = depressionSum * 2;
    _anxietyScore = anxietySum * 2;
    _stressScore = stressSum * 2;

    if (kDebugMode) {
      print(
        "Calculated Scores: D:$_depressionScore, A:$_anxietyScore, S:$_stressScore",
      );
    }

    setState(() {
      _showResults = true;
      _isGeneratingInsight = true; // Start loading indicator for insights
      _generatedInsight = null; // Clear previous insight
    });

    _fetchInsights(); // Fetch insights automatically
  }

  Future<void> _fetchInsights() async {
    if (_depressionScore < 0 || _anxietyScore < 0 || _stressScore < 0) return;

    String depressionSeverity = _getSeverity("Depression", _depressionScore);
    String anxietySeverity = _getSeverity("Anxiety", _anxietyScore);
    String stressSeverity = _getSeverity("Stress", _stressScore);
    String? insight;

    try {
      insight = await getVertexInsights(
        _depressionScore,
        depressionSeverity,
        _anxietyScore,
        anxietySeverity,
        _stressScore,
        stressSeverity,
      );
    } catch (e) {
      insight = "Failed to generate insights: ${e.toString()}";
      if (kDebugMode) {
        print("Error in _fetchInsights (Vertex AI call): $e");
      }
    }

    // Save to Firestore regardless of insight generation success
    await _saveResultsToFirestore(
      depressionSeverity,
      anxietySeverity,
      stressSeverity,
      insight,
    );

    if (mounted) {
      setState(() {
        _generatedInsight = insight;
        _isGeneratingInsight = false;
      });
    }
  }

  Future<void> _saveResultsToFirestore(
    String depressionSeverity,
    String anxietySeverity,
    String stressSeverity,
    String? insight,
  ) async {
    try {
      await _firestore.collection('history').add({
        'timestamp': FieldValue.serverTimestamp(),
        'depressionScore': _depressionScore,
        'depressionSeverity': depressionSeverity,
        'anxietyScore': _anxietyScore,
        'anxietySeverity': anxietySeverity,
        'stressScore': _stressScore,
        'stressSeverity': stressSeverity,
        'insight': insight ?? "No insight generated.",
        'rawAnswers': _answers,
        'tag': 'dass_21',
      });
      if (kDebugMode) {
        print("Results saved to Firestore successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving results to Firestore: $e");
      }
    }
  }

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
            const SizedBox(height: 30),
            Text(
              "Question ${index + 1} of ${_questions.length}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
            const SizedBox(height: 50),
            Text(
              questionText,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            Slider(
              // ignore: deprecated_member_use
              year2023: false,
              value: _answers[questionId] ?? 0.0,
              min: 0.0,
              max: 3.0,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaireView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 8.0),
          child: Text(
            "Please read each statement and select Never, Sometimes, Often or Almost Always, which indicates how much the statement applied to you over the past week. There are no right or wrong answers. Do not spend too much time on any statement.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _questions.length,
            itemBuilder: (context, index) => _buildQuestionPage(context, index),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
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
                const SizedBox(width: 80),
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
                    _calculateAndShowResults();
                  }
                },
                child: Text(
                  _currentPage < _questions.length - 1
                      ? "Next"
                      : "View Results",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSeverity(String category, int score) {
    Map<String, List<Map<String, dynamic>>> severityLevels = {
      "Depression": [
        {"range": const RangeValues(0, 9), "label": "Normal"},
        {"range": const RangeValues(10, 13), "label": "Mild"},
        {"range": const RangeValues(14, 20), "label": "Moderate"},
        {"range": const RangeValues(21, 27), "label": "Severe"},
        {"range": const RangeValues(28, 42), "label": "Extremely Severe"},
      ],
      "Anxiety": [
        {"range": const RangeValues(0, 7), "label": "Normal"},
        {"range": const RangeValues(8, 9), "label": "Mild"},
        {"range": const RangeValues(10, 14), "label": "Moderate"},
        {"range": const RangeValues(15, 19), "label": "Severe"},
        {"range": const RangeValues(20, 42), "label": "Extremely Severe"},
      ],
      "Stress": [
        {"range": const RangeValues(0, 14), "label": "Normal"},
        {"range": const RangeValues(15, 18), "label": "Mild"},
        {"range": const RangeValues(19, 25), "label": "Moderate"},
        {"range": const RangeValues(26, 33), "label": "Severe"},
        {"range": const RangeValues(34, 42), "label": "Extremely Severe"},
      ],
    };

    for (var level in severityLevels[category]!) {
      RangeValues range = level["range"];
      if (score >= range.start && score <= range.end) {
        return level["label"];
      }
    }
    return "N/A";
  }

  Widget _buildScoreRow(BuildContext context, String category, int score) {
    String severity = _getSeverity(category, score);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$category:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("$score", style: Theme.of(context).textTheme.titleLarge),
                Text(
                  "($severity)",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Your DASS-21 Scores",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_depressionScore >= 0)
            _buildScoreRow(context, "Depression", _depressionScore),
          if (_anxietyScore >= 0)
            _buildScoreRow(context, "Anxiety", _anxietyScore),
          if (_stressScore >= 0)
            _buildScoreRow(context, "Stress", _stressScore),
          const SizedBox(height: 20),
          Text(
            "Note: These scores are indicative and not a diagnosis. If you have concerns, please consult a healthcare professional.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_isGeneratingInsight)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Generating insights..."),
                  ],
                ),
              ),
            )
          else if (_generatedInsight != null) ...[
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          size: 18,
                          color: Colors.amber[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          "AI Generated Insights",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _generatedInsight!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Case where insight generation might have silently failed before _generatedInsight is set.
            // Or if you want a button to retry. For now, this part is empty.
            const Center(child: Text("Insights will appear here.")),
          ],
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Done"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showResults ? "DASS-21 Results" : "DASS-21 Questionnaire"),
        elevation: 1,
        scrolledUnderElevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: _showResults ? _buildResultsView() : _buildQuestionnaireView(),
        ),
      ),
    );
  }
}
