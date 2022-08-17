import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meraki/Screens/voice.dart';
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
class _ChatRoomState extends State<ChatRoom>{

  AuthMethods authMethods =new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;


  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
        builder: (context,AsyncSnapshot<dynamic> snapshot){
        count = snapshot.data.size;

        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.size,
            itemBuilder: (context,index){
            return ChatRoomsTile(
                snapshot.data!.docs[index]["chatsroomid"]
                    .toString().replaceAll('_', "")
                    .replaceAll(Constants.myName, "").toUpperCase(),
                snapshot.data!.docs[index]["chatsroomid"]
            );
            }
        ): Container();
        },);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }
  getUserInfo() async{
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    //print("${Constants.myName}");

    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream=value;
      });
    });
  }
  var name ="Untitled";

  createChatroomAndStartConversation({required String username}){

    if (username != Constants.myName){
      String chatRoomId = getChatRoomId(username,Constants.myName);
      print(username);
      List<String> users = [username,Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatsroomid" : chatRoomId,
      };
      //print(chatRoomId);
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)),
                );
      });
    }
    else{
      print("You Can;t send msg to yourself");
    }
  }
  QuerySnapshot? searchSnapshot;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(193, 205, 169, 1),
      appBar:appBarMain1(context),
      body:
          chatRoomList(),


      floatingActionButton: GestureDetector(

        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => createChatroomAndStartConversation(
                  username: name+(count.toString())
          )));
          //Constants.interval+=1;
          print("count:");
          print(count);
          print(Constants.interval);
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                child:
                Image.asset("assets/images/plus1.png",
                    height: MediaQuery.of(context).size.height*0.1,
                    //fit: BoxFit.fill
                )),
            Positioned(
              left: 3,
                bottom: 7,
                child:
                Image.asset("assets/images/plus2.png",
                  height: MediaQuery.of(context).size.height*0.09,
                  //fit: BoxFit.fill
                )),
          ],
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat
    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  //const ChatRoomsTile({Key? key}) : super(key: key);
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName,this.chatRoomId);
  QuerySnapshot? searchSnapshot;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder:
        (context) => ConversationScreen(chatRoomId)
        ));
      },
              child: Column(
                children:[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                    children: [
                Stack(
                        children: <Widget>[
                          Positioned(
                        child:
                        Image.asset("assets/images/chats1.png",
                          height: MediaQuery.of(context).size.height*0.1,
                    //fit: BoxFit.fill
                )),
                    Positioned(
                        left: 3,
                        bottom: 7,
                        child:
                        Image.asset("assets/images/chats2.png",
                        height: MediaQuery.of(context).size.height*0.09,
            //fit: BoxFit.fill
            )),
            ],
    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          child: Column(
                            children:[
                              Text(userName,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black
                                ),
                              ),
                              Text("Manas",
                              style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(175, 175, 175, 1)
                              ),
                            ),
                            ]
                          ),
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Container(
                            child: Icon(Icons.more_vert,
                                size:40
                            )
                          ),
                        ),




        ],
      ),
                  ),
                  Image.asset("assets/images/line.png",
                    height: MediaQuery.of(context).size.height*0.009,
                    width: MediaQuery.of(context).size.width,
                    //fit: BoxFit.fill
                  ),
                ]
              )
    );
  }
}
getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}