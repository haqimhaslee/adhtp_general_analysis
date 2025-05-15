// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepInsight extends StatefulWidget {
  const DeepInsight({super.key});
  @override
  State<DeepInsight> createState() => _DeepInsightState();
}

class _DeepInsightState extends State<DeepInsight> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode(debugLabel: 'TextField');
  bool _loading = false;
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, idx) {
                      return MessageWidget(
                        text: _messages[idx].text,
                        isFromUser: _messages[idx].isFromUser,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _textFieldFocus,
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Ask anything about ADHTP and DASS 21...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon:
                              _loading
                                  ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed:
                                          () => _sendChatMessage(
                                            _textController.text,
                                          ),
                                    ),
                                  ),
                        ),
                        onSubmitted: _sendChatMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    if (message.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _messages.add(Message(text: message, isFromUser: true));
    });
    _textController.clear();
    _scrollDown();

    var responseText = '';
    setState(() {
      _messages.add(Message(text: responseText, isFromUser: false));
    });

    try {} catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const MessageWidget({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isFromUser)
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/postalhub_logo.jpg'),
            radius: 13,
          ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color:
                  isFromUser
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
              borderRadius: BorderRadius.circular(13),
            ),
            child: MarkdownBody(
              selectable: true,
              data: text,
              onTapLink: (text, href, title) {
                if (href != null) launchUrl(Uri.parse(href));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Message {
  final String text;
  final bool isFromUser;

  Message({required this.text, required this.isFromUser});
}
