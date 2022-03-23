import 'package:e_voting/src/models/voter.model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_voting/src/utilities/constants.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/components/title.view.dart';

class VoterListView extends StatefulWidget {
  const VoterListView({Key? key}) : super(key: key);

  @override
  _VoterListViewState createState() => _VoterListViewState();
}

class _VoterListViewState extends State<VoterListView> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  bool selected = false;
  bool selected1 = false;
  List<VoterModel> voters = Cosntants.voters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/voter/new').then((value) {
            setState(() {
              voters = Cosntants.voters;
            });
          });
          Fluttertoast.showToast(
            msg: 'Añadir votante',
            toastLength: Toast.LENGTH_LONG,
            webBgColor: "linear-gradient(to right, #000000, #000000)"
          );
        },

        child: Icon(
          Icons.add,
          // color: Colors.white,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Title1View(
            title: 'Administración de votantes',
            isLargeSreen: isLargeSreen,
            isMediumSreen: isMediumSreen
          ),
          SizedBox(height: 32.0),
          Table(
            border: TableBorder.all(
                color: Colors.black45
            ),
            columnWidths: const <int,TableColumnWidth> {
              0: const FixedColumnWidth(50), //cheackbox
              1: const FixedColumnWidth(100), //id
              2: const FlexColumnWidth(3), //names
              3: const FlexColumnWidth(3), //dni
              4: const FlexColumnWidth(3),//email
              5: const FlexColumnWidth(3), //function
              6: const FlexColumnWidth(3), //actions
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100
                  ),
                  children: [
                    IconButton(

                      icon: Icon(
                        selected?Icons.check_box:Icons.check_box_outline_blank
                      ),
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                          voters.map((v) => {
                            v.selected = !v.selected,
                          }).toList();
                        });
                      },
                    ),
                    Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'NOMBRES',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'CÉDULA',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'EMAIL',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'FUNCIÓN',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'ACCIONES',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ]
              ),
            ]
          ),
          voters.length<=0?
          Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height/4
            ),
            child: Text(
              'No tiene votantes almacenados',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ):Table(
            border: TableBorder.all(
                color: Colors.black45
            ),
            columnWidths: const <int,TableColumnWidth> {
              0: const FixedColumnWidth(50), //cheackbox
              1: const FixedColumnWidth(100), //id
              2: const FlexColumnWidth(3), //names
              3: const FlexColumnWidth(3), //dni
              4: const FlexColumnWidth(3),//email
              5: const FlexColumnWidth(3), //function
              6: const FlexColumnWidth(3), //actions
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: voters.map((v) {
              return TableRow(
                  children: [
                    IconButton(
                      icon: Icon(
                          v.selected?Icons.check_box:Icons.check_box_outline_blank
                      ),
                      onPressed: () {
                        setState(() {
                          v.selected = !v.selected;
                        });
                      },
                    ),
                    Text(
                      '${v.id}',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${v.name} ${v.lastName}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${v.dni}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${v.email}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${v.function}',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: v.selected?Theme.of(context).primaryColor:Colors.black45,
                          ),
                          onPressed: !v.selected?null:() {
                            Fluttertoast.showToast(
                                msg: 'Editar elección'
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: v.selected?Colors.redAccent:Colors.black45,
                          ),
                          onPressed: !v.selected?null:() {
                            Fluttertoast.showToast(
                                msg: 'Editar elección'
                            );
                          },
                        ),
                      ],
                    )
                  ]
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
