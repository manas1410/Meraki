import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meraki/helper/helperfunction.dart';
import 'package:meraki/services/auth.dart';
import 'package:meraki/services/database.dart';
import 'package:meraki/widget/widgets.dart';



class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();

  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;
  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      databaseMethods
          .getUserByUseremail(emailTextEditingController.text)
          .then((val) {
        setState(() {
          snapshotUserInfo = val;
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo!.docs[0]['name']);
          //print("${snapshotUserInfo!.docs[0]['name']} hello hellooo");
        });
      });
      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Scaffold()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 237, 223, 1),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.amberAccent,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height:50,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset("assets/images/cyber.png",
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 40,),
                    Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Welcome Back!",
                            style: welcomeback(),

                          ),
                        )),
                        SizedBox(height: 40,),
                        Wrap(
                          children: [
                            Container(
                              child: Image.asset("assets/images/user.png",
                                height: 50,
                              ),
                            ),
                            Container(
                              width: 250,
                              child: TextFormField(
                              validator: (val) {
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                    ? null
                                    : "Please enter valid email address";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: InputDecoration(
                                  hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color.fromRGBO(175, 175, 175, 1))

                              ),
                          ),
                            ),]
                        ),
                    SizedBox(
                      height: 8,
                    ),
                Wrap(
                  children: [
                    Container(
                      child: Image.asset("assets/images/pass.png",
                        height: 50,
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return (val!.length > 6)
                              ? null
                              : "Please provide password atleast 7 character";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Color.fromRGBO(175, 175, 175, 1))

                        ),
                      ),
                    ),]
        )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forget Password?",
                      style: mediumTextFieldStyle(),
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xff2A60BC),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color:Color(0xff2A55BC),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width:50 ,
                    ),
                    Image.asset("assets/images/google.png",
                      height: 30,
                    ),
                    Text("  Sign In with Google",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: mediumTextFieldStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Register Now ",
                        style: TextStyle(
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 110,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
