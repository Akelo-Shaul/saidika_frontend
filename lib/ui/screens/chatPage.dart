
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<FocusNode> focusNodes = [
  FocusNode(),
];

class ChatPage extends StatefulWidget {

  final String receiverName;
  final String receiverId;
  final String senderId;
  final String chatId;

  const ChatPage({super.key, required this.receiverName, required this.receiverId, required this.senderId, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  String? receiverTitle;
  String? chatReceiverId;
  String? chatId;

  final TextEditingController messageController = TextEditingController();

  List<Messages> messages = [
    Messages(message: 'Hello',isSentByMe: true, isDelivered: true, isRead: true, time: DateTime.now().subtract(Duration(minutes: 5))),
    Messages(message: 'Hello too', time: DateTime.now().subtract(Duration(minutes: 5)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: 'Wazzah', time: DateTime.now().subtract(Duration(minutes: 5)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: "This doesn't work", time: DateTime.now().subtract(Duration(minutes: 7)), isDelivered: true, isRead: true, isSentByMe: true),
    Messages(message: 'I saw a monkey', time: DateTime.now().subtract(Duration(minutes: 20)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: 'Jeez I have to make this long to ensure that the space used is as reliable as termed so lets see if this is any good', time: DateTime.now().subtract(Duration(minutes: 3)), isDelivered: true, isRead: true, isSentByMe: false),
  ];

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<void> addChat() async{
    print("Add chat function called");

    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');
    String? userId = sharedPreferences.getString('userId');

    var url = Uri.parse('http://192.168.6.16:8080/api/v1/messages/$userId/${chatReceiverId}');
    print(url);

    Map<String, dynamic> message = {
      "text": messageController.text,
    };

    print("Message object: $message");

    var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": '$userToken'
        },
        body: json.encode(message)
    );

    print(response.body);

    messageController.clear();
  }


  Future<void> getAllMessages() async {
    print("All Messages function called");

    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');

    var url = Uri.parse('http://192.168.6.16:8080/api/v1/get_messages/$chatId');
    print(url);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": '$userToken'
      },
    );

    //TODO: Continue to get messages using chat Id

    // print(jsonDecode(response.body));

    // chatsData = jsonDecode(response.body);
    //
    // print(chatsData);
    // print(chatsData.id);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> appBarActions = [
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {
          // Handle notification button press
          Navigator.pushNamed(context, '/notifications');
        },
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          // Handle settings button press
          Navigator.pushNamed(context, '/settings');
        },
      ),
    ];

    // @override
    // void dispose() {
    //   messageController.dispose();
    //   super.dispose();
    // }

    return Scaffold(
      appBar: appBarWithActions(
          context,
          receiverTitle!,
          appBarActions,
        titleStyle: appTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.bold)
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(context, messages[index]);
                },
              ),
            ),
          ),
          _buildMessageInputField(this.context,this.messageController, addChat),
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    sortMessagesByTime();
    setState(() {
      chatReceiverId = widget.receiverId;
      receiverTitle = widget.receiverName;
      chatId = widget.chatId;
    });
  }

  void sortMessagesByTime() {
    messages.sort((a, b) => a.time.compareTo(b.time));
  }

}

Widget _buildMessageBubble(BuildContext context, Messages message) {
  BorderRadius borderRadius = message.isSentByMe
      ? BorderRadius.only(
      topLeft: Radius.circular(3),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20)
  )
      : BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(3),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20)
  );


  return Align(
    alignment: message.isSentByMe ? Alignment.centerLeft : Alignment.centerRight,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.isSentByMe) // Display avatar on the right if the message is sent
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: imageAsset(
              isNormalImage: true,
              fileName: 'profile.jpg',
              imgHeight: 35,
              imgWidth: 35,
            ),
          ),
        if (message.isSentByMe)
          SizedBox(width: 8.0),
        IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
                children: [
                  Text(
                    message.message,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat.jm().format(message.time).toString(),
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!message.isSentByMe)
          SizedBox(width: 8.0),
        if (!message.isSentByMe) // Display avatar on the left if the message is received
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: imageAsset(
              isNormalImage: true,
              fileName: 'profile.jpg',
              imgHeight: 35,
              imgWidth: 35,
            ),
          ),
      ],
    ),
  );
}

Widget _buildMessageInputField(BuildContext context, TextEditingController messageController, Future<void> Function() addChat) {

  void sendMessage() {
    print("Send button pressed"); // Add this line
    if (messageController.text.isNotEmpty) {
      print("Message: ${messageController.text}"); // Check the message content
      addChat();
    } else {
      print("Message is empty!"); // Check if the message is empty
    }
  }


  return Container(
    width: double.infinity, // Ensure the Container takes up the full width
    child: Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt),
              padding: EdgeInsets.all(3), // Optional: Reduce the padding around the icon
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: TextField(
                  controller: messageController,
                  focusNode: focusNodes[0],
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4),
                  ),
                  style: appTextTheme(context)
                      .labelMedium?.copyWith(fontSize: 16)
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.attach_file),
              padding: EdgeInsets.all(0), // Optional: Reduce the padding around the icon
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                sendMessage();
              },
            ),
          ),
        ],
      ),
    ),
  );
}


