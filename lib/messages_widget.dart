import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              color: sender == "me" ? Colors.redAccent : Colors.green,
              shape: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  sender,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text.trim(),
                style: TextStyle(
                    fontWeight:
                        sender == "me" ? FontWeight.w300 : FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
