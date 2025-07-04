import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../l10n/app_translations.dart';
import '../config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late String _welcomeMessage;

  @override
  void initState() {
    super.initState();
    _welcomeMessage = ''; // Will be set in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final translations = AppTranslations.of(context);
    if (_messages.isEmpty) {
      _welcomeMessage = translations.translate('chatWelcome');
      _messages.add(ChatMessage(
        text: _welcomeMessage,
        isUser: false,
      ));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _isLoading = true;
    });

    String response;
    try {
      response = await _getBotResponse(text);
    } catch (e) {
      response = AppTranslations.of(context).translate('chatOffline');
    }

    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
      ));
    });

    _scrollToBottom();

    // Always set loading to false at the end
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _getBotResponse(String userMessage) async {
    try {
      final response = await http
          .post(
            Uri.parse(Config.apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'message': userMessage}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botResponse = data['response'] as String?;
        if (botResponse != null && botResponse.trim().isNotEmpty) {
          // Show backend response directly
          return botResponse;
        }
      }
      return AppTranslations.of(context).translate('chatOffline');
    } catch (e) {
      return AppTranslations.of(context).translate('chatOffline');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.translate('chatAssistant')),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildMessageComposer(context, translations),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer(
      BuildContext context, AppTranslations translations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: translations.translate('askQuestion'),
                border: InputBorder.none,
              ),
              onSubmitted: _handleSubmitted,
              enabled: !_isLoading,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isLoading
                ? null
                : () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8.0),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: isUser ? Colors.blue : Colors.green,
      child: Icon(
        isUser ? Icons.person : Icons.security,
        color: Colors.white,
      ),
    );
  }
}
