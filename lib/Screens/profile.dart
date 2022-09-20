import 'package:flutter/material.dart';
import 'package:meraki/Screens/login_screen.dart';

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 237, 223, 1),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height*0.3,
                child: Column(
                    children:[ Image.asset(
                      "assets/images/profilepic.png",
                      height: MediaQuery.of(context).size.height*0.16,
                    ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.04,
                      ),
                      Text(Constants.email,style: TextStyle(fontSize: 25,color: Colors.green))
                    ]
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.82,
                height: MediaQuery.of(context).size.height * 0.28,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(198, 195, 189, 1),
                  borderRadius: BorderRadius.circular(35),

                ),
                child: Align(
                  child:Text("Cyber Crime Unit, Special Cell, Delhi Police, MHA",style: TextStyle(fontSize: 24)),

                )
            ),
            SizedBox(
              height:  MediaQuery.of(context).size.width * 0.14,
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
              height:  MediaQuery.of(context).size.width * 0.25,
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

