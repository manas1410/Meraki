import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:meraki/voice.dart';
import '../helper/constants.dart';
import '../helper/helperfunction.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widget/widgets.dart';
import 'Conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int count = 0;

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;
  var valueText = "";
  TextEditingController _textFieldController = new TextEditingController();

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          count = snapshot.data.size;
        }
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                  snapshot.data!.docs[index]["chatsroomid"]
                      .toString()
                      .replaceAll('_', "")
                      .replaceAll(Constants.myName, "")
                      .toUpperCase(),
                  snapshot.data!.docs[index]["chatsroomid"]);
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    //print("${Constants.myName}");

    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  createChatroomAndStartConversation({required String username}) {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      //print(username);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatsroomid": chatRoomId,
      };
      //print(chatRoomId);
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)),
        );
      });
    } else {
      print("You Cant send msg to yourself");
    }
  }

  QuerySnapshot? searchSnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarMain1(context),
        body: chatRoomList(),
        floatingActionButton: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('ENTER FILE NAME'),
                    content: TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Enter here"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        //color: Colors.red,
                        //textColor: Colors.white,
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                      // TextButton(
                      //   //color: Colors.green,
                      //   //textColor: Colors.white,
                      //   child: Text('OK'),
                      //   onPressed: () {
                      //     setState(() {
                      //       //codeDialog = valueText;
                      //       createChatroomAndStartConversation(
                      //           username: _textFieldController.text);
                      //     });
                      //   },
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            primary: Colors.green[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 13),
                        ),
                        onPressed: () {
                          setState(() {
                            createChatroomAndStartConversation(
                                username: _textFieldController.text);
                          });
                        },
                      ),
                    ],
                  );
                });

            //Constants.interval+=1;
            print("count:");
            print(count);
            print(Constants.interval);
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Image.asset(
                    "assets/images/plus1.png",
                    height: MediaQuery.of(context).size.height * 0.08,
                    //fit: BoxFit.fill
                  )),
              Positioned(
                  left: 15,
                  bottom: 13,
                  child: Icon(
                    Icons.messenger_outline_rounded,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height * 0.045,
                  )),
              Positioned(
                  left: 21,
                  bottom: 23,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height * 0.03,
                  )),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}

class ChatRoomsTile extends StatelessWidget {
  //const ChatRoomsTile({Key? key}) : super(key: key);
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);
  QuerySnapshot? searchSnapshot;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(chatRoomId)));
        },
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(children: [
              Positioned(
                  left: 3,
                  bottom: 7,
                  child: Image.asset("assets/images/chats2.png",
                      height: MediaQuery.of(context).size.height * 0.04,
                      fit: BoxFit.fill)),
              SizedBox(
                height: 65,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: Column(children: [
                    Text(
                      // _ChatRoomState.name;
                      userName,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    // Text(
                    //   "Manas",
                    //   style: TextStyle(
                    //       fontSize: 22,
                    //       color: Color.fromRGBO(175, 175, 175, 1)),
                    // ),
                  ]),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert,
                            size: MediaQuery.of(context).size.height * 0.045))
                  ],
                ),
              ),
            ]),
          ),
          Image.asset(
            "assets/images/line_1.png",
            height: MediaQuery.of(context).size.height * 0.009,
            width: MediaQuery.of(context).size.width,
            //fit: BoxFit.fill
          ),
        ]));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
