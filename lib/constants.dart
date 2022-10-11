import 'package:flutter/material.dart';

const kSmallTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
);
const kTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const kSubTitleTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);
const kTextFiledDecoration = InputDecoration(
  hintText: 'Enter a value.',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.teal, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.teal, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const kTableTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: Colors.green,
);
const kTableCellTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 13,
  color: Colors.green,
);
BoxDecoration KBoxedContainer = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  border: Border.all(style: BorderStyle.solid, color: Colors.teal),
);
const KTextFiledDecorationSecond = InputDecoration(
  hintText: 'Enter a value.',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
);
const KTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.teal,
  fontSize: 20,
);
