import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../helper/constants.dart';
import '../services/database.dart';
import 'package:translator/translator.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening_red = false;
  bool _isListening_green = false;
  String _text = "";
  String _text1 = "";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  GoogleTranslator translator = new GoogleTranslator();
  Map<String, String> language = {
    'English': 'en',
    "Hindi": 'hi',
    'Punjabi': 'pa',
    'Bengali': 'bn',
    'Gujarati': 'gu',
    'Kannada': 'kn',
    'Malayalam': 'ml',
    'Marathi': 'mr',
    'Nepali': 'ne',
    'Tamil': 'ta',
    'Telegu': 'te',
    'Urdu': 'ur'
  };

  final FlutterTts flutterTts = FlutterTts();

  void trans() {
    translator
        .translate(_text, from: 'auto', to: Constants.language)
        .then((output) {
      setState(() {
        _text1 = Constants.language.toString() + ": " + output.toString();
        Constants.converted_text = output.toString();
      });
      print(_text1);
    });
  }

  Stream? chatMessageStream;
  //QuerySnapshot? snapshot;
  text_to_speech(String text0) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text0);
    print(text0);
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          //print(chatMessageStream);
          return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                return MessageTile(snapshot.data!.docs[index]["message"],
                    snapshot.data!.docs[index]["sendBy"] == Constants.myName);
              });
        } else {
          print("chatMessageStream");
          print(chatMessageStream);
          return Container();
        }
      },
    );
  }

  sendMessage_red() {
    if (_text.isNotEmpty) {
      Map<String, dynamic> messageMap1 = {
        "message": "English: " + _text + "\n" + _text1,
        "sendBy": "Untitled0",
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap1);
      messageController.text = "";
    }
  }

  sendMessage_green() {
    if (_text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": "English: " + _text + "\n" + _text1,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);

      messageController.text = "";
    }
  }

  @override
  void initState() {
    //print("haha"+ widget.chatRoomId);
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBarMain2(),
      backgroundColor: Color.fromRGBO(245, 237, 223, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(children: <Widget>[
        AvatarGlow(
          animate: _isListening_red,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: _listen_red,
            child: Icon(_isListening_red ? Icons.mic : Icons.mic_none),
            heroTag: "fab1",
          ),
        ),
        AvatarGlow(
          animate: _isListening_green,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: _listen_green,
            child: Icon(_isListening_green ? Icons.mic : Icons.mic_none),
            heroTag: "fab2",
          ),
        ),
      ]),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg3.jpg"),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.14,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(40, 20, 60, 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.red, Colors.red]),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              )),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Text(
                                "English",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    MediaQuery.of(context).size.width *
                                        0.04),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(193, 205, 169, 1),
                                Color.fromRGBO(193, 205, 169, 1)
                              ]),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              )),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.12,
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: Constants.language,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Constants.language = newValue!;
                                    });
                                  },
                                  items: language
                                      .map((string, value) {
                                    return MapEntry(
                                      string,
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(string),
                                      ),
                                    );
                                  })
                                      .values
                                      .toList(),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.001,
                  ),
                  Text(
                      "Accuracy: " +
                          ((Constants.confidence) * 100).toString() +
                          "%",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06))
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                    bottom: MediaQuery.of(context).size.height * 0.16,
                    //left: MediaQuery.of(context).size.width*0.03,
                    //right: MediaQuery.of(context).size.width*0.03
                  ),
                  child: ChatMessageList()),


            ],
          ),
        ),
      ),
    );
  }

  void _listen_red() async {
    if (!_isListening_red) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _text = "";
        _text1 = "";
        setState(() => _isListening_red = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;

            if (val.hasConfidenceRating && val.confidence > 0) {
              Constants.confidence = val.confidence;
              print("vvjhvjhvjvhjvhjvjhvjh");
              print(Constants.confidence);
            }

            trans();
          }),
        );
      }
    } else {
      setState(() => _isListening_red = false);
      _speech.stop();
      sendMessage_red();
    }
  }

  void _listen_green() async {
    if (!_isListening_green) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _text = "";
        _text1 = "";
        setState(() => _isListening_green = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;


            trans();
          }),
        );
      }
    } else {
      setState(() => _isListening_green = false);
      _speech.stop();
      sendMessage_green();
    }
  }
}

class MessageTile extends StatelessWidget {

  final _ConversationScreenState obj = new _ConversationScreenState();
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
        margin: EdgeInsets.symmetric(vertical: 4),

        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(-3, 3),
                      )
                    ], shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () {
                        obj.text_to_speech(Constants.converted_text);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.1,


                          child: Image(
                            image: AssetImage('assets/images/img.png'),
                            height: 50,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: isSendByMe
                            ? [
                          Color.fromRGBO(193, 205, 169, 1),
                          Color.fromRGBO(193, 205, 169, 1)
                        ]
                            : [
                          Color.fromRGBO(239, 178, 167, 1),
                          Color.fromRGBO(239, 178, 167, 1)
                        ]),
                    borderRadius: isSendByMe
                        ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                        : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23))),
                child: Text(message,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ));
  }
}
