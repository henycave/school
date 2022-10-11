import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final iconData;
  final subject;
  final title;
  final submitDate;
  final color;
  final onTap;

  NotificationCard(
      {this.iconData,
      this.subject,
      this.submitDate,
      this.color,
      this.title,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: onTap,
          leading: iconData,
          title: Text('$title: $subject'),
          subtitle: Text(submitDate),
        ),
      ),
    );
  }
}
