
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/messages.dart';
import 'package:saidika_ui/utils/route.dart';
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
  final XFile? chatPhoto;

  const ChatPage({super.key, required this.receiverName, required this.receiverId, required this.senderId, required this.chatId, this.chatPhoto});

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  String receiverTitle = 'User';
  String? chatReceiverId;
  String? chatId;
  XFile? _selectedImage;
  List<dynamic> chatsList = [];

  // final ScrollController _scrollController = ScrollController();
  final FlutterListViewController _scrollController = FlutterListViewController();

  final TextEditingController messageController = TextEditingController();


  List<Messages> messages = [
    Messages(message: 'Hello',isSentByMe: true, isDelivered: true, isRead: true, time: DateTime.now().subtract(const Duration(minutes: 5))),
    Messages(message: 'Hello too', time: DateTime.now().subtract(const Duration(minutes: 5)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: 'Wazzah', time: DateTime.now().subtract(const Duration(minutes: 5)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: "This doesn't work", time: DateTime.now().subtract(const Duration(minutes: 7)), isDelivered: true, isRead: true, isSentByMe: true),
    Messages(message: 'I saw a monkey', time: DateTime.now().subtract(const Duration(minutes: 20)), isDelivered: true, isRead: true, isSentByMe: false),
    Messages(message: 'Jeez I have to make this long to ensure that the space used is as reliable as termed so lets see if this is any good', time: DateTime.now().subtract(const Duration(minutes: 3)), isDelivered: true, isRead: true, isSentByMe: false),
  ];

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<void> addChat() async{
    print("Add chat function called");

    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');
    String? userId = sharedPreferences.getString('userId');
    String? notifsToken = sharedPreferences.getString("notifsToken");
    String? userName = sharedPreferences.getString('userName');

    var url = Uri.parse('https://saidika-backend.onrender.com/api/v1/messages/sendMessage/$chatReceiverId');
    print(url);

    // Map<String, dynamic> message = {
    //   "text": messageController.text,
    // };

    // print("Message object: $message");
    // print(userToken);

    var headers = {
      "Content-Type": "application/json",
      if (userToken != null) 'Authorization': userToken
    };

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll(headers);

    request.fields.addAll({
      "text": "${messageController.text}"
    });

    print(request.headers);
    print(request.fields);

    String trimmedText = messageController.text.length > 15
        ? '${messageController.text.substring(0, 15)}...'
        : messageController.text;


    Map<String, dynamic> notif = {
      "title": "$userName",
      "body": "$trimmedText",
      "topic":"I wish I knew",
      // TODO: GEt actual user notification
      "token": '$notifsToken'
    };

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      //TODO: Finish with the adding of notification API
      var notifUrl = Uri.parse('https://saidika-backend.onrender.com/notification');

      var request = await http.post(
        notifUrl,
        headers: {
          "Authorization": '$userToken'
        },
        body: jsonEncode(notif)
      );
    }
    else {
      print(response.reasonPhrase);
    }

    // var response = await http.post(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": '$userToken'
    //     },
    //     body: json.encode(msg_model)
    // );

    // print('Response body ${response.body}');

    messageController.clear();
    getAllMessages();
  }


  Future<void> getAllMessages() async {
    print("All Messages function called");

    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');

    var url = Uri.parse('https://saidika-backend.onrender.com/api/v1/messages/get_messages/$chatId');
    print(url);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": '$userToken'
      },
    );

    //TODO: Continue to get messages using chat Id

    Map responseData = jsonDecode(response.body);
    print(responseData['body']);

    if (response.body != 'null' && response.body.isNotEmpty){
      setState(() {
        chatsList = responseData['body'];
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add a slight delay to ensure the ListView is fully rendered
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      });
    }

    print(chatsList);
    // print(chatsData.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      print(_selectedImage);
    });
  }


  Future<void> _openCamera() async {
    final result = await Navigator.pushNamed(context, cameraPage);
    if (result is XFile) {
      print('Image Result: ${result.path}');

      setState(() {
        _selectedImage = result;
        print('Selected Image Path: ${_selectedImage!.path}');
      });
    } else {
      print('No image captured');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<Map<String, String?>> getUserPreferences() async {
    final SharedPreferences sharedPreferences = await prefs;

    String? userId = sharedPreferences.getString('userId');
    String? userToken = sharedPreferences.getString('userToken');
    String? userName = sharedPreferences.getString('userName');

    // Return the values as a Map
    return {
      'userId': userId,
      'userToken': userToken,
      'userName': userName,
    };
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> appBarActions = [
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {
          // Handle notification button press
          Navigator.pushNamed(context, '/notifications');
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings),
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
          receiverTitle,
          appBarActions,
        titleStyle: appTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.bold)
      ),
      body: Stack(
        children: [
          Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: FlutterListView(
                  delegate: FlutterListViewDelegate(
                    (BuildContext context, int index) => Container(
                      child: _buildMessageBubble(context, chatsList[index], getUserPreferences()),
                    ),
                    childCount: chatsList.length,
                      initIndex: chatsList.length - 1,
                      initOffset: 0,
                      initOffsetBasedOnBottom: false
                  ),
                  controller: _scrollController,
                ),
              ),
            ),
            _buildMessageInputField(this.context,messageController, addChat, _openCamera),
          ],
          ),
          _selectedImage != null
              ? Stack(
                children: [Positioned(
                  bottom: 65,
                  left: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Ensure the image is also clipped
                    child: Stack(
                      children: [
                        Positioned(
                          child: SizedBox(
                            height: 244,
                            width: 144,
                            child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover), // Use fit to avoid overflow
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                  Positioned(
                    bottom: 282,
                    left: 162,
                    child: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: _removeImage, // Remove image action
                    ),
                  ),
                ]
              ) : Container(),

        ]
      ),
    );

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('I NNITIaTing THE STATE ::))):)<:)');
    super.initState();
    setState(() {
      chatReceiverId = widget.receiverId;
      receiverTitle = widget.receiverName;
      chatId = widget.chatId;
      _selectedImage = widget.chatPhoto;
    });
    sortMessagesByTime();
    getAllMessages();
    print(widget.chatId);
    print(widget.receiverName);
    print('THe cat Photo');
    print(widget.chatPhoto?.path);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }




  void sortMessagesByTime() {
    messages.sort((a, b) => a.time.compareTo(b.time));
  }

}

Widget _buildMessageBubble(BuildContext context, dynamic message, Future<Map<String, String?>> getUserPreferences) {
  return FutureBuilder(
      future: getUserPreferences,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error fetching user preferences');
        } else if (!snapshot.hasData) {
          return const Text('No data');
        } else {
          final userPreferences = snapshot.data;
          final userId = userPreferences!['userId'];

          bool isSentByMe = message['sender'] == userId;

          BorderRadius borderRadius = isSentByMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              );

          return Align(
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isSentByMe) // Display avatar on the right if the message is sent
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageAsset(
                      isNormalImage: true,
                      fileName: 'profile.jpg',
                      imgHeight: 35,
                      imgWidth: 35,
                    ),
                  ),
                if (!isSentByMe)
                  const SizedBox(width: 8.0),
                IntrinsicWidth(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        // color: isSentByMe ? Colors.blue : Colors.grey[300],
                        color: Colors.grey,
                        borderRadius: borderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
                        children: [
                          Text(
                            '${message['text']}',
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DateFormat('hh:mm').format(DateTime.parse(message['timestamp'])),
                              style: const TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isSentByMe)
                  const SizedBox(width: 8.0),
                if (isSentByMe) // Display avatar on the left if the message is received
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
      }
  );
}


Widget _buildMessageInputField(BuildContext context, TextEditingController messageController, Future<void> Function() addChat, Future<void> Function() openCamera) {

  void sendMessage() {
    print("Send button pressed"); // Add this line
    if (messageController.text.isNotEmpty) {
      print("Message: ${messageController.text}"); // Check the message content
      addChat();
    } else {
      print("Message is empty!"); // Check if the message is empty
    }
  }



  return SizedBox(
    width: double.infinity, // Ensure the Container takes up the full width
    child: Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: (){
                openCamera();
              },
              icon: const Icon(Icons.camera_alt),
              padding: const EdgeInsets.all(3), // Optional: Reduce the padding around the icon
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
                  decoration: const InputDecoration(
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
              icon: const Icon(Icons.send),
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


