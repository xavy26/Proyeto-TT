import 'package:flutter/material.dart';

class Title1View extends StatelessWidget {

  String title;
  bool isLargeSreen;
  bool isMediumSreen;


  Title1View({
    required this.title,
    required this.isLargeSreen,
    required this.isMediumSreen
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        title,
        textAlign: TextAlign.center,
        style: isLargeSreen || isMediumSreen ? Theme.of(context).textTheme.headline3 : Theme.of(context).textTheme.headline5
    );
  }
}
