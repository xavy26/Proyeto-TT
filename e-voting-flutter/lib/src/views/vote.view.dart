import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/items/vote.item.dart';

class VoteView extends StatefulWidget {
  const VoteView({Key? key}) : super(key: key);

  @override
  _VoteViewState createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
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
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Text(
          'Elecciones integrantes al OCS',
          textAlign: TextAlign.center,
          style: isLargeSreen || isMediumSreen ? Theme.of(context).textTheme.headline3 : Theme.of(context).textTheme.headline5
        ),
        SizedBox(height: 32.0),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: isLargeSreen?96.0:isMediumSreen?32.0:16,
          mainAxisSpacing: isLargeSreen?64.0:32.0,
          crossAxisCount: isLargeSreen||isMediumSreen?2:1,
          children: List.generate(2, (i) {
            return Center(child: VoteItem());
          }),
        )
      ],
    );
  }
}
