
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../helper/constants.dart';
import '../services/database.dart';
import '../widget/widgets.dart';
import 'chatsRoomScreen.dart';
import 'package:translator/translator.dart';

class ConversationScreen extends StatefulWidget {
  //const ConversationScreen({Key? key}) : super(key: key);
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text ="";
  String _text1 ="";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  GoogleTranslator translator = new GoogleTranslator();


  void trans()
  {
    translator.translate(_text,from: 'auto', to: 'hi')
        .then((output)
        {
      setState((){
        _text1=output.toString();
      });
      print(_text1);
  });
  }

  Stream? chatMessageStream;
  //QuerySnapshot? snapshot;


  Widget ChatMessageList(){
  return StreamBuilder(
    stream: chatMessageStream,
    builder: (context, AsyncSnapshot<dynamic> snapshot){
      if (snapshot.hasData) {
        //print(chatMessageStream);
        return ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              return MessageTile(
                  snapshot.data!.docs[index]["message"],
                  snapshot.data!.docs[index]["sendBy"] == Constants.myName
              );
            });
      }
      else{
        print("chatMessageStream");
        print(chatMessageStream);
        return Container();
      }
    },
  );
  }
  sendMessage(){
    if (_text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message": _text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      Map<String,dynamic> messageMap1 = {
        "message": _text1,
        "sendBy" : "Untitled0",
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap1);
      messageController.text ="";
    }
  }

  @override
  void initState() {
    //print("haha"+ widget.chatRoomId);
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream =value;
      });
    });
    super.initState();
    _speech = stt.SpeechToText();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain2(context),
        backgroundColor: Color.fromRGBO(245, 237, 223, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      //appBar: appBarMain2(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            /*Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(239, 178, 167, 1),
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                child: Container()Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                  color: Colors.black54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
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
                          child: Icon(Icons.send,size: 25,)
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
              /*final translation =
               _text.translate(from: 'auto', to: 'hi');
              _text1 = translation.text;
              print("manaas");
              print(_text1);
              print(translation.text);*/

            trans();

          }
          ),

        );

      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      sendMessage();
    }
  }
}
class MessageTile extends StatelessWidget {
  //const MessageTile({Key? key}) : super(key: key);
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0:24 ,
          right: isSendByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical: 4),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe?
            [
               Color.fromRGBO(193, 205, 169, 1),
              Color.fromRGBO(193, 205, 169, 1)

            ]:[
          Color.fromRGBO(239, 178, 167, 1),
            Color.fromRGBO(239, 178, 167, 1)

              ]
          ),
          borderRadius: isSendByMe?
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ):
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )

        ),
        child:Text(message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          )),
      ),
    );
  }
}


/*class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;*/
  /*bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: {},
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
*/

/*GoogleTranslator translator = GoogleTranslator();
String translated = 'Translation';
late stt.SpeechToText _speech;
bool _isListening = false;
String _text = 'Press the button and start speaking';

@override
void initState() {
  super.initState();
  _speech = stt.SpeechToText();
}
*/
/*
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Card(
      margin: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Enter Text'),
            onChanged: (text) async {

              setState(() {
                translated = translation.text;
              });
            },
          ),
          Text(translated)
        ],
      ),
    ),
  );
}
*/