import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/chat.dart';
import 'package:saidika_ui/utils/route.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int _selectedIndex = 2; // Assuming Search is at index 1, adjust if needed

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      //Handling navigation to different pages
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, homePage);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, search);
          break;
        case 2:

          break;
        case 3:
          Navigator.pushReplacementNamed(context, profile);
          break;
      }
    });
  }

  //List of previous messages
  List<ChatTemp> chatList = [
    ChatTemp(
        name: 'Shaul Akelo',
        text: 'Hello User',
        isDelivered: true,
        isRead: false,
        time: '19.20',
        imageUrl: 'assets/avatar.jpg'
    ),
    ChatTemp(
        name: 'Donald Akula',
        text: 'Go home',
        isDelivered: false,
        isRead: false,
        time: '17.20',
        imageUrl: 'assets/avatar.jpg'
    ),
    ChatTemp(
        name: 'Herald Owuor',
        text: 'Little one',
        isDelivered: true,
        isRead: true,
        time: '19.20',
        imageUrl: 'assets/avatar.jpg'
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Icon(
                    Icons.email,
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: chatList.length,
                  itemBuilder: (context, index){
                    final chat = chatList[index];

                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        chat_page,
                        arguments: {
                          'receiverName': 'Derozen', // Replace with actual receiver name
                          'receiverId': 'Namya Biz' // Replace with actual receiver ID
                        },
                      );
                      // setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: imageAsset(
                                      isNormalImage: true,
                                      fileName: 'profile.jpg',
                                      imgHeight: 45,
                                      imgWidth: 45,
                                    ),
                                  ),
                                  SizedBox(width: 7), // Adjust the spacing as needed
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                                    children: [
                                      Text(
                                        chat.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: .3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            chat.isDelivered ? Icons.done_all_outlined : Icons.done,
                                            size: 20,
                                            color: chat.isRead ? Colors.blue : Colors.black,
                                          ),
                                          SizedBox(width: 4), // Adjust spacing between icon and text
                                          Text(
                                            chat.text,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                chat.time,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  }
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}


//Icons.done_all_outlined for ticks