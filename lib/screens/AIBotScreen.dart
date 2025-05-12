import 'package:flutter/material.dart';
import 'package:labs/screens/SettingsScreen.dart';

class AIBotScreen extends StatefulWidget {
  const AIBotScreen({super.key});

  @override
  State<AIBotScreen> createState() => _AIBotScreenState();
}

class _AIBotScreenState extends State<AIBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _showCustomChat = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
    });

    // Simulate AI response after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: _getAIResponse(text),
              isUser: false,
            ),
          );
        });
      }
    });
  }

  String _getAIResponse(String text) {
    if (text.toLowerCase().contains('subscription')) {
      return 'I can help you manage your subscriptions! Would you like to see your upcoming bills or get recommendations on how to optimize your spending?';
    } else if (text.toLowerCase().contains('spend')) {
      return 'Based on your subscription history, you spend about \$45.96 per month on subscriptions. Your most expensive subscription is Netflix at \$15.99/month.';
    } else if (text.toLowerCase().contains('save')) {
      return 'To save money, you could consider sharing your Netflix Premium plan with family members, which would reduce your cost by about \$5 per month.';
    } else {
      return 'I\'m your subscription assistant. I can help you track your subscriptions, analyze your spending patterns, and provide cost-saving recommendations. How can I help you today?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white), // Change icon color to white
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Change icon color to white
            onPressed: () {
              if (_showCustomChat) {
                setState(() {
                  _showCustomChat = false;
                });
              }
            },
          ),
        ],
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
        centerTitle: true,
      ),
      body: _showCustomChat
          ? _buildChatInterface()
          : _buildPresetQuestions(),
    );
  }

  Widget _buildPresetQuestions() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // AI Bot Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), // Adjust for black theme
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.smart_toy,
            size: 40,
            color: Theme.of(context).colorScheme.primary, // Change icon color to white
          ),
        ),
        
        const SizedBox(height: 10),
        
        const Text(
          'How can I help you?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
        
        const SizedBox(height: 5),
        
        Text(
          'Ask me anything about your subscriptions',
          style: TextStyle(
            color: Colors.grey[400], // Adjust text color for dark theme
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Preset questions
        _buildPresetQuestionButton(
          'What\'s my total subscription cost this month?',
          Icons.paid,
        ),
        
        _buildPresetQuestionButton(
          'Which subscription costs me the most?',
          Icons.trending_up,
        ),
        
        _buildPresetQuestionButton(
          'How can I save money on my subscriptions?',
          Icons.savings,
        ),
        
        _buildPresetQuestionButton(
          'When is my next payment due?',
          Icons.event,
        ),
        
        const Spacer(),
        
        // Custom chat button
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCustomChat = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Change button color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Start Custom Chat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetQuestionButton(String question, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _showCustomChat = true;
          });
          
          // Add a small delay before sending the message
          Future.delayed(const Duration(milliseconds: 300), () {
            _handleSubmitted(question);
          });
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[800], // Adjust for black theme
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white, // Change icon color to white
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white, // Change icon color to white
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1), // Adjust for black theme
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.smart_toy,
                          size: 40,
                          color: Colors.white, // Change icon color to white
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Ask me anything about your subscriptions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey, // Adjust text color for dark theme
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) => _messages[_messages.length - index - 1],
                ),
        ),
        const Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.black, // Set background color to black
          ),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.white), // Set icon color to white
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[700], // Set input field background to dark gray
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Ask me anything...',
                  hintStyle: TextStyle(color: Colors.white60), // Set hint text color
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white), // Set icon color to white
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent, // Change avatar color
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.blueAccent
                        : Colors.grey[800], // Change message background for dark theme
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.white60, // Adjust text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
