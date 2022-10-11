import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color color;
  final image;
  final title;
  final textSize;
  final Function onTap;

  ReusableCard(
      {@required this.color,
      this.onTap,
      this.image,
      this.title,
      this.textSize = 30.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: image),
            Flexible(
              child: SizedBox(
                height: 20,
              ),
            ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(10.0),
      ),
    );
  }
}
