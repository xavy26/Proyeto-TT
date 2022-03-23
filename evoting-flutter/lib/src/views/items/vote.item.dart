import 'package:e_voting/src/utilities/constants.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VoteItem extends StatefulWidget {
  const VoteItem({Key? key}) : super(key: key);

  @override
  _VoteItemState createState() => _VoteItemState();
}

class _VoteItemState extends State<VoteItem> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  Future<void> _showDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Confirmación del voto',
              style: Theme.of(context).textTheme.headline5,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Está por votar por el partido político: TU Estudiantes. ¿Esta seguro de su elección?',
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    title: Text('Si'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        Cosntants.vote = true;
                      });
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                    title: Text('No'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(
          width: 2.0,
          color: Theme.of(context).colorScheme.primary,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Text(
            'TU Estudiantes',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Container(
              width: isLargeSreen||isMediumSreen?size.width/8:size.width/6,
              height: isLargeSreen||isMediumSreen?size.width/8:size.width/6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: AssetImage('assets/images/tu.png')
                )
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Candidatos:',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: isLargeSreen||isMediumSreen?size.width/22:size.width/11,
                height: isLargeSreen||isMediumSreen?size.width/22:size.width/11,
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: AssetImage('assets/images/user_desfault.png'),
                        fit: BoxFit.contain
                    )
                ),
              );
            })
          ),
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: 'Ver detalles');
            },
            child: Text(
              'Mas detalles',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                decoration: TextDecoration.underline
              ),
            ),
          ),
          SizedBox(height: 8.0),
          IconButton(
            onPressed: Cosntants.vote?null:() {
              _showDialog(context);
            },
            icon: Icon(
              Cosntants.vote?Icons.check_box:Icons.check_box_outlined,
              color: !Cosntants.vote?Colors.black87:Colors.black45,
              size: isLargeSreen||isMediumSreen?size.width/30:size.width/13,
            ),
          ),
          SizedBox(height: isLargeSreen||isMediumSreen?32.0:16.0)
        ],
      ),
    );
  }
}
