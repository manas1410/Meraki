import 'package:flutter/material.dart';

import '../helper/authentication.dart';
import '../helper/constants.dart';
import '../helper/helperfunction.dart';
import '../services/auth.dart';
import '../services/database.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  AuthMethods authMethods =new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 237, 223, 1),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height*0.4,
            child: Image.asset(
                "assets/images/profilepic.png",
              height: MediaQuery.of(context).size.height*0.2,
            ),
          ),
        Container(
            width: MediaQuery.of(context).size.width * 0.82,
            height: MediaQuery.of(context).size.height * 0.28,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Color.fromRGBO(198, 195, 189, 1),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                BoxShadow(
                //offset: Offset(0, 4),
                color: Colors.grey, //edited
            spreadRadius: 4,
            blurRadius: 10  //edited
        )]
    ),
    ),
          SizedBox(
            height:  MediaQuery.of(context).size.width * 0.1,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Authenticate()));
              },
              child: Container(
                alignment: Alignment.centerRight,
                  child: Wrap(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text("LogOut",style: TextStyle(fontSize: 20),)),
                    Image.asset("assets/images/logout.png",
                      height:MediaQuery.of(context).size.height*0.07 ,)
                  ])
              )
            ),
          ),
          SizedBox(
            height:  MediaQuery.of(context).size.width * 0.30,
          ),
          Wrap(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),

                  child: Image.asset("assets/images/icon.png",
                    width: MediaQuery.of(context).size.width*0.04,

                  ),
                ),
              ),
              Container(
                child: Image.asset("assets/images/Translata.png",
                  width: MediaQuery.of(context).size.width*0.4,
                ),
              )
            ],
          )
        ],
      )
    );
  }
}

