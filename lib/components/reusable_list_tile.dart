import 'package:flutter/material.dart';
import 'package:school/constants.dart';

class ReusableListTile extends StatelessWidget {
  final title;
  final text;
  ReusableListTile({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: Text(
          title,
          style: kTitleTextStyle,
        ),
        subtitle: Text(
          text,
          style: kSubTitleTextStyle,
        ),
      ),
    );
  }
}
