import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/items/results.item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultView extends StatefulWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late bool isLargeSreen;
  late bool isMediumSreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 64,
          left: 16.0,
          right: 16.0,
        ),
        crossAxisSpacing: isLargeSreen?96.0:isMediumSreen?32.0:16.0,
        mainAxisSpacing: isLargeSreen?64.0:isMediumSreen?32.0:16.0,
        crossAxisCount: isLargeSreen?3:isMediumSreen?2:1,
        children: List.generate(5, (i) {
          return Center(child: ResultsItem());
        }),
      ),
    );
  }
}
