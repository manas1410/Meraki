import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

InputDecoration textFieldInputDecoration(String xtext){
  return InputDecoration(
    hintText: xtext,
    border: OutlineInputBorder(),
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
    fontSize: 16,
  );
}

TextStyle welcomeback(){
  return TextStyle(
    fontSize: 30,
    fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      foreground: Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,

        end: Alignment.bottomCenter,
        colors: <Color>[
          Color.fromRGBO(11, 33, 1, 1),
          Color.fromRGBO(44, 137, 0, 1),

          //add more color here.
        ],
      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
  );
}
TextStyle mediumTextFieldStyle(){
  return TextStyle(
      fontSize: 17,
      fontFamily: 'Montserrat'
  );
}
