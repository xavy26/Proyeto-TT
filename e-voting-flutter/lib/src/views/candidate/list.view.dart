import 'package:e_voting/src/utilities/constants.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CandidateListView extends StatefulWidget {
  const CandidateListView({Key? key}) : super(key: key);

  @override
  _CandidateListViewState createState() => _CandidateListViewState();
}

class _CandidateListViewState extends State<CandidateListView> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  bool selected = false;
  bool selected1 = false;

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
          if (Cosntants.voters.isNotEmpty) {
            Navigator.pushNamed(context, '/candidate/new');
            Fluttertoast.showToast(
                msg: 'Añadir elecion',
                toastLength: Toast.LENGTH_LONG,
                webBgColor: "linear-gradient(to right, #000000, #000000)"
            );
          } else {
            Fluttertoast.showToast(
                msg: 'Debe tener regsitrados votantes antes de crear candidatos',
                toastLength: Toast.LENGTH_LONG,
                webBgColor: "linear-gradient(to right, #000000, #000000)"
            );
          }
        },
        child: Icon(
          Icons.add,
          // color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          Text(
              'Administración de candidatos',
              textAlign: TextAlign.center,
              style: isLargeSreen || isMediumSreen ? Theme.of(context).textTheme.headline3 : Theme.of(context).textTheme.headline5
          ),
          SizedBox(height: 64.0),
          Table(
            border: TableBorder.all(
                color: Colors.black45
            ),
            columnWidths: const <int,TableColumnWidth> {
              0: const FixedColumnWidth(50),
              1: const FlexColumnWidth(1), //id
              2: const FlexColumnWidth(3), // voter
              3: const FlexColumnWidth(3), // position
              4: const FixedColumnWidth(120), // photo
              6: const FixedColumnWidth(300),
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
                        });
                      },
                    ),
                    Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'NOMBRE',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'POSICIÓN',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'FOTO',
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
              TableRow(
                  children: [
                    IconButton(
                      icon: Icon(
                          selected1?Icons.check_box:Icons.check_box_outline_blank
                      ),
                      onPressed: () {
                        setState(() {
                          selected1 = !selected1;
                        });
                      },
                    ),
                    Text(
                      '001',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Edgar Patricio Sanchez Malla',
                    ),
                    Text(
                      'Representante estudiantil',
                    ),
                    Container(
                      width: 100.0,
                      height: 100.0,
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/tu.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: selected1?Theme.of(context).primaryColor:Colors.black45,
                          ),
                          onPressed: !selected1?null:() {
                            Fluttertoast.showToast(
                                msg: 'Editar elección'
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: selected1?Theme.of(context).primaryColor:Colors.black45,
                          ),
                          onPressed: !selected1?null:() {
                            Fluttertoast.showToast(
                                msg: 'Editar elección'
                            );
                          },
                        ),
                      ],
                    )
                  ]
              ),
            ],
          )
        ],
      ),
    );
  }
}
