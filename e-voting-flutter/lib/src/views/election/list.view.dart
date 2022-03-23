import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/components/title.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ElectionListView extends StatefulWidget {
  const ElectionListView({Key? key}) : super(key: key);

  @override
  _ElectionListViewState createState() => _ElectionListViewState();
}

class _ElectionListViewState extends State<ElectionListView> {

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
            Navigator.pushNamed(context, '/election/new');
            Fluttertoast.showToast(
              msg: 'Añadir elecion',
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
          children: [
            Title1View(
              title: 'Administración de eleciones',
              isLargeSreen: isLargeSreen,
              isMediumSreen: isMediumSreen
            ),
            SizedBox(height: 64.0),
            Table(
              border: TableBorder.all(
                color: Colors.black45
              ),
              columnWidths: const <int,TableColumnWidth> {
                0: const FixedColumnWidth(50),
                1: const FlexColumnWidth(2),
                2: const FlexColumnWidth(3),
                3: const FlexColumnWidth(6),
                4: const FixedColumnWidth(180),
                5: const FixedColumnWidth(180),
                6: const FixedColumnWidth(120),
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
                      'DESCRIPCIÓN',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'FECHA INICIO',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'FECHA FIN',
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
                      'Miembros al OCS',
                    ),
                    Text(
                      'Votaciones para elejir a los miembros del OCS',
                    ),
                    Text(
                      '24-04-2020 08H00',
                      textAlign: TextAlign.center
                    ),
                    Text(
                      '24-04-2020 16H00',
                      textAlign: TextAlign.center
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
                      'Miembros al OCS',
                    ),
                    Text(
                      'Votaciones para elejir a los miembros del OCS',
                    ),
                    Text(
                      '24-04-2020 08H00',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '24-04-2020 16H00',
                      textAlign: TextAlign.center,
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
