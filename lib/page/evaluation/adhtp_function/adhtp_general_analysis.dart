import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adhtp_general_analysis/page/evaluation/adhtp_function/vertex_ai_func.dart';

class AdhtpGeneralAnalysis extends StatefulWidget {
  const AdhtpGeneralAnalysis({super.key});

  @override
  State<AdhtpGeneralAnalysis> createState() => _AdhtpGeneralAnalysisState();
}

class _AdhtpGeneralAnalysisState extends State<AdhtpGeneralAnalysis> {
  File? _selectedImageFile;
  String? _aiResponse;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _aiResponse = null; // Clear previous response
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = null; // Clear previous response
    });

    try {
      final Uint8List imageBytes = await _selectedImageFile!.readAsBytes();
      const String userPrompt =
          "Interpret this HTP drawing. Focus on identifying key visual factors based on the provided system instructions and then synthesize their potential meanings. Do not list parameters, but describe the observed factors and their implications.";

      // Call the AI function
      final String? response = await generateHtpAnalysisFromImage(
        imageBytes,
        userPrompt,
      );

      setState(() {
        _aiResponse = response;
      });
    } catch (e) {
      setState(() {
        _aiResponse = "Error during analysis: $e";
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Analysis failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADTHP General Analysis"),
        backgroundColor: Colors.transparent, // Or your preferred color
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_selectedImageFile != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: Image.file(
                      _selectedImageFile!,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Text('Could not display image preview.'),
                    ),
                  ),
                )
              else
                Container(
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.image_search),
                label: const Text('Select Image'),
                onPressed:
                    _isLoading
                        ? null
                        : () => _showImageSourceActionSheet(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('Analyze Drawing'),
                onPressed:
                    (_selectedImageFile != null && !_isLoading)
                        ? _analyzeImage
                        : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_aiResponse != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    _aiResponse!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
