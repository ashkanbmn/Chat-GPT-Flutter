import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/messages_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MessagesWidget> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;
  bool _isTyping = false;
  String yourApiKey = "Your Api Key";

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance.builder(
      yourApiKey,
    );
  }

  @override
  void dispose() {
    chatGPT!.genImgClose();
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    final message = MessagesWidget(
      text: _controller.text,
      sender: "me",
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    _translateAndInsert(message.text);
  }

  void _translateAndInsert(String text) async {
    final request =
        CompleteReq(prompt: text, model: kTranslateModelV3, max_tokens: 200);

    final response = await chatGPT!.onCompleteStream(request: request).first;
    insertNewData(response!.choices[0].text);
  }

  void insertNewData(String response) {
    final botMessage = MessagesWidget(
      text: response,
      sender: "chat gpt",
    );

    setState(() {
      _messages.insert(0, botMessage);
      _isTyping = false;
    });
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _sendMessage(),
                decoration:
                    const InputDecoration.collapsed(hintText: "type ..."),
              ),
            ),
          ),
          ButtonBar(
            children: [
              Card(
                elevation: 8,
                shape: const StadiumBorder(),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatGPT")),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            if (_isTyping)
              Lottie.asset("assets/dots.json", width: 90, height: 90),
            const Divider(height: 2),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextInput(),
            )
          ],
        ),
      ),
    );
  }
}
