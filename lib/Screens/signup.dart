import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meraki/helper/helperfunction.dart';
import 'package:meraki/services/auth.dart';
import 'package:meraki/services/database.dart';
import 'package:meraki/widget/widgets.dart';

class SignUp extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
  new TextEditingController();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();

  signMeUP() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpwithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)
          .then((value) {
        //print("${value.uid}");

        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
        };

        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Scaffold(

        )));
      });
    }
  }
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 237, 223, 1),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height - 210,
          alignment: Alignment.bottomCenter,
          child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children:<Widget>[
                      Positioned(
                          child:
                          Image.asset("assets/images/cyber1.png",
                            height: MediaQuery.of(context).size.height*0.4,
                            width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill
                       )),
                      Positioned(
                          child:
                          Image.asset("assets/images/cyber1.png",
                              height: MediaQuery.of(context).size.height*0.36,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height*0.01,
                        right: MediaQuery.of(context).size.width*0.04,
                          child:
                          Image.asset("assets/images/cyber.png", height: 200,)),
                    ],
                  ),
                ),
                //SizedBox(height:50,),
                SizedBox(height: MediaQuery.of(context).size.width*0.01,),
                Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Let's get started.",
                        style: welcomeback(),

                      ),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Wrap(
                        children:[
                          Container(
                            child: Image.asset("assets/images/user.png",
                              height: MediaQuery.of(context).size.height*0.06,
                            ),
                          ),
                          Container(
                          width:  MediaQuery.of(context).size.width*0.83,
                          height: MediaQuery.of(context).size.height*0.06,
                          child: TextFormField(
                            validator: (val) {
                              return (val!.isEmpty || val.length < 4)
                                  ? "Wrong Username"
                                  : null;
                            },
                            controller: userNameTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: InputDecoration(
                                hintText: "USERNAME",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Color.fromRGBO(175, 175, 175, 1))

                            ),
                          ),
                        ),
                        ]
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                          Wrap(
                            children:[
                              Container(
                                child: Icon(Icons.email_outlined,color: Colors.grey,),
                                  height: MediaQuery.of(context).size.height*0.06,
                                  width: MediaQuery.of(context).size.width*0.12
                                ),
                              Container(
                              width:  MediaQuery.of(context).size.width*0.83,
                              height: MediaQuery.of(context).size.height*0.06,
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
                                  hintText: "EMAIL",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color.fromRGBO(175, 175, 175, 1))

                              ),
                            ),
                        ),]
                          ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                      Wrap(
                        children: [
                          Container(
                            child: Image.asset("assets/images/pass.png",
                              height:  MediaQuery.of(context).size.height*0.06,
                            ),
                          ),
                          Container(
                          width:  MediaQuery.of(context).size.width*0.83,
                          height: MediaQuery.of(context).size.height*0.06,
                          child: TextFormField(
                            obscureText: _isObscure,
                            validator: (val) {
                              return (val!.length > 6)
                                  ? null
                                  : "Please provide password atleast 7 character";
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextFieldStyle(),
                            decoration: InputDecoration(
                                hintText: "PASSWORD",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Color.fromRGBO(175, 175, 175, 1)),
                              suffixIcon: IconButton(
                            icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                              color: Color.fromRGBO(245, 237, 223, 1),),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                            ),
                          ),
                        ),
                        ]
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                /*Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        "Forget Password?",
                        style: mediumTextFieldStyle(),
                      ),
                    )),*/
                SizedBox(
                  height: MediaQuery.of(context).size.width*0.05,
                ),
                GestureDetector(
                  onTap: () {
                    signMeUP();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width*0.15,
                    width: MediaQuery.of(context).size.width*0.40,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(38, 108, 5, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Montserrat',
                          fontSize: 23,
                        )),
                  ),
                ),
                SizedBox(
                  height:MediaQuery.of(context).size.width*0.05,
                ),
                /*Container(
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
                ),*/
                SizedBox(
                  height: 4,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account? ",
                      style: mediumTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Sign Now ",
                          style: TextStyle(
                            color: Color.fromRGBO(120, 76, 66, 1),
                            fontFamily: 'Montserrat',
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 140,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
