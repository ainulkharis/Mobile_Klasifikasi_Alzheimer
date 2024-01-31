import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatbotCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatbotDetail()),
        );
      },
      child: Card(
        elevation: 5.0,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.yellow,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            FontAwesomeIcons.robot,
            size: 50,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}

class ChatbotDetail extends StatefulWidget {
  @override
  _ChatbotDetailState createState() => _ChatbotDetailState();
}

class _ChatbotDetailState extends State<ChatbotDetail> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _chatHistory = [];

  void _sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://4b5a-114-142-169-30.ngrok-free.app/get_response'), // Ganti dengan alamat server Flask Anda
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_message': message,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      String chatbotResponse = responseBody['response'];
      setState(() {
        _chatHistory.add(ChatMessage(sender: 'User', message: message));
        _chatHistory.add(ChatMessage(sender: 'Chatbot', message: chatbotResponse));
      });
    } else {
      // Handle errors here
      print('Failed to get response from server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            
            SizedBox(width: 8.0),
            Text("Chatbot Alzha"),
            Icon(
              FontAwesomeIcons.robot,
              color: Colors.orange,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Ganti dengan warna atau gambar latar belakang yang diinginkan
          color: Colors.grey[200], // Contoh: Latar belakang berwarna abu-abu
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(_chatHistory[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        // Ganti dengan warna latar belakang yang sesuai
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String message = _messageController.text;
                      if (message.isNotEmpty) {
                        _messageController.clear();
                        _sendMessage(message);
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildChatBubble(ChatMessage chatMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: chatMessage.sender == 'User' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: chatMessage.sender == 'User' ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            chatMessage.message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}
