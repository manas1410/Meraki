import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../services/database.dart';
import '../widget/widgets.dart';
import 'Conversation_screen.dart';
import 'chatsRoomScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen>{

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
      });
    }
    );
  }

  Widget searchList(){
    return searchSnapshot!=null ?ListView.builder(
        itemCount: searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
              userName: searchSnapshot!.docs[index]['name'],
              userEmail: searchSnapshot!.docs[index]['email']
          );
        }
    ):Container();
  }
  createChatroomAndStartConversation({required String username}){

    if (username != Constants.myName){
      String chatRoomId = getChatRoomId(username,Constants.myName);
      print(username);
      print(Constants.myName);

      List<String> users = [username,Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatsroomid" : chatRoomId,
      };
      //print(chatRoomId);
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  chatRoomId
              )));
    }
    else{
      print("You Can;t send msg to yourself");
    }
  }
  Widget SearchTile({required String userName, required String userEmail}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(30)
        ),
        child:Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,style: mediumTextFieldStyle()),
                SizedBox(height: 4,),
                Text(userEmail,style: mediumTextFieldStyle())
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                createChatroomAndStartConversation(
                    username: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blue,
                          Colors.lightBlueAccent,
                          Colors.blue,
                          Colors.blue
                        ]
                    ),
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: Text("Message",style: mediumTextFieldStyle()),
              ),
            )
          ],
        )
    );
  }
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: appBarMain2(context),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Search username...",
                            hintStyle: TextStyle(
                                color: Colors.black54
                            ),
                            border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      //height: 40,
                      //width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue,
                                  Colors.lightBlueAccent,
                                  Colors.blue,
                                  Colors.blue
                                ]
                            ),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search,size: 40,)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            searchList()
          ],
        ),
      ),
    );
  }
}


