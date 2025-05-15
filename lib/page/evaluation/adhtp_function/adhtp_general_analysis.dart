// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:adhtp_general_analysis/page/evaluation/adhtp_function/vertex_ai_func.dart';

// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdhtpGeneralAnalysis extends StatefulWidget {
  const AdhtpGeneralAnalysis({super.key});

  @override
  State<AdhtpGeneralAnalysis> createState() => _AdhtpGeneralAnalysisState();
}

class _AdhtpGeneralAnalysisState extends State<AdhtpGeneralAnalysis> {
  Uint8List? _imageData;
  String? _aiResponse;
  bool _isLoading = false;
  // bool _isSaving = false; // Optional: for a separate saving indicator
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        if (!mounted) return;
        setState(() {
          _imageData = imageBytes;
          _aiResponse = null; // Clear previous response
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _pickImageFromWebDialog(BuildContext context) async {
    _urlController.clear();
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool isDialogLoading = false;
        String? dialogError;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Enter Image URL'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com/image.png',
                      errorText: dialogError,
                    ),
                    onChanged: (_) {
                      if (dialogError != null) {
                        setDialogState(() {
                          dialogError = null;
                        });
                      }
                    },
                  ),
                  if (isDialogLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  onPressed:
                      isDialogLoading
                          ? null
                          : () async {
                            final String url = _urlController.text.trim();
                            if (url.isEmpty) {
                              setDialogState(() {
                                dialogError = 'URL cannot be empty';
                              });
                              return;
                            }
                            if (!(Uri.tryParse(url)?.isAbsolute ?? false)) {
                              setDialogState(() {
                                dialogError = 'Invalid URL format';
                              });
                              return;
                            }

                            setDialogState(() {
                              isDialogLoading = true;
                              dialogError = null;
                            });

                            try {
                              final response = await http
                                  .get(Uri.parse(url))
                                  .timeout(const Duration(seconds: 15));

                              if (!mounted) {
                                return; // Check if main widget is still mounted
                              }

                              if (response.statusCode == 200) {
                                final contentType =
                                    response.headers['content-type'];
                                if (contentType != null &&
                                    contentType.startsWith('image/')) {
                                  setState(() {
                                    _imageData = response.bodyBytes;
                                    _aiResponse = null;
                                  });
                                  if (Navigator.of(dialogContext).canPop()) {
                                    Navigator.of(dialogContext).pop();
                                  }
                                } else {
                                  final error =
                                      'URL does not point to a valid image (invalid content-type).';
                                  setDialogState(() {
                                    dialogError = error;
                                  });
                                  ScaffoldMessenger.of(
                                    this.context,
                                  ).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              } else {
                                final error =
                                    'Failed to load image. Status: ${response.statusCode}';
                                setDialogState(() {
                                  dialogError = error;
                                });
                                ScaffoldMessenger.of(
                                  this.context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              }
                            } catch (e) {
                              if (!mounted) return;
                              final error =
                                  'Error fetching image: ${e.toString().substring(0, (e.toString().length > 60) ? 60 : e.toString().length)}...';
                              setDialogState(() {
                                dialogError = error;
                              });
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text('Error fetching image: $e'),
                                ),
                              );
                            } finally {
                              // Check if dialog is still active before calling setDialogState
                              if (dialogContext.mounted) {
                                setDialogState(() {
                                  isDialogLoading = false;
                                });
                              }
                            }
                          },
                  child: const Text('Fetch Image'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveAnalysisToFirebase(
    Uint8List imageData,
    String aiResponse,
  ) async {
    if (!mounted) return;

    try {
      final timestamp = Timestamp.now();
      final String fileName =
          'history/${DateTime.now().millisecondsSinceEpoch}_${imageData.length}.jpg';

      final Reference storageRef = FirebaseStorage.instance.ref().child(
        fileName,
      );
      final UploadTask uploadTask = storageRef.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      final doc = await FirebaseFirestore.instance.collection('history').add({
        'aiResponse': aiResponse,
        'imageUrl': imageUrl,
        'timestamp': timestamp,
        'tag': 'htp_analysis',
      });

      if (kDebugMode) {
        print("Saved analysis to Firestore with ID: ${doc.id}");
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analysis saved successfully to Firebase!'),
        ),
      );
    } catch (e, stack) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save analysis to Firebase: $e')),
      );
      if (kDebugMode) {
        print('Error saving to Firebase: $e');
        print(stack);
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageData == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    try {
      const String userPrompt =
          "Interpret this HTP drawing. Focus on identifying key visual factors based on the provided system instructions and then synthesize their potential meanings. Do not list parameters, but describe the observed factors and their implications.";

      final String? response = await generateHtpAnalysisFromImage(
        _imageData!,
        userPrompt,
      ).timeout(const Duration(seconds: 60));

      if (!mounted) return;

      if (response != null && response.trim().isNotEmpty) {
        setState(() {
          _aiResponse = response;
        });

        // Save to Firebase but don't wait for it to complete UI update
        _saveAnalysisToFirebase(_imageData!, response);
      } else {
        setState(() {
          _aiResponse = "AI response was empty.";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("AI did not return a valid response.")),
        );
      }
    } catch (e, stack) {
      if (!mounted) return;

      final String errorMessage = 'Analysis failed: ${e.toString()}';
      setState(() {
        _aiResponse = errorMessage;
      });

      if (kDebugMode) {
        print(errorMessage);
        print(stack);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Renamed to avoid conflict
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 28.0, 0.0, 28.0),
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
              if (!kIsWeb &&
                  (Platform.isWindows || Platform.isLinux || Platform.isMacOS))
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('From Web URL (Desktop)'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImageFromWebDialog(
                      this.context,
                    ); // this.context is AdhtpGeneralAnalysisState's context
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
        title: const Text("ADHTP General Analysis"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_imageData != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Image.memory(
                        _imageData!,
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
                      _isLoading // || _isSaving // Optional: disable if saving
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
                      (_imageData != null &&
                              !_isLoading) // && !_isSaving // Optional
                          ? _analyzeImage
                          : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading) // This covers AI analysis
                  const Center(child: CircularProgressIndicator())
                // else if (_isSaving) // Optional: for a dedicated saving indicator
                //   const Center(child: Column(children: [CircularProgressIndicator(), Text("Saving...")]))
                else if (_aiResponse != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
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
      ),
    );
  }
}
