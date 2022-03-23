import 'package:flutter/material.dart';

import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/components/title.view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ElectionNewView extends StatefulWidget {
  const ElectionNewView({Key? key}) : super(key: key);

  @override
  _ElectionNewViewState createState() => _ElectionNewViewState();
}

class _ElectionNewViewState extends State<ElectionNewView> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _dateStart = TextEditingController();
  TextEditingController _dateEnd = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  Future<Null> _showDatePicker(BuildContext context,bool band) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year+10),
    );
    if (picked != null) {
      String date = '${picked.day}-${picked.month}-${picked.year} ${picked.hour}:${picked.minute}';
      setState(() {
        band?_dateStart.text = date:_dateEnd.text = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('E-Voting'),
        ),
      body: ListView(
        children: [
          SizedBox(height: 64.0),
          Title1View(
            title: 'Nueva elección',
            isLargeSreen: isLargeSreen,
            isMediumSreen: isMediumSreen
          ),
          SizedBox(height: 64.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width/3,
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la elección',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary
                      )
                    )
                  ),
                ),
              ),
              SizedBox(width: 48.0),
              Container(
                width: size.width/3,
                child: TextFormField(
                  controller: _desc,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary
                      )
                    )
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 48.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width/3,
                child: TextFormField(
                  controller: _dateStart,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Fecha de inicio',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.black45,
                      ),
                      onPressed: () => _showDatePicker(context,true),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary
                      )
                    )
                  ),
                  onTap: () => _showDatePicker(context,true),
                ),
              ),
              SizedBox(width: 64.0),
              Container(
                width: size.width/3,
                child: TextFormField(
                  controller: _dateEnd,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Fecha de finalización',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.black45,
                        ),
                        onPressed: () => _showDatePicker(context,false),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary
                          )
                      )
                  ),
                  onTap: () => _showDatePicker(context,false),
                ),
              ),
            ],
          ),
          SizedBox(height: 48.0),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width/2.5,
                vertical: 16.0
            ),
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Guardar');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: isLargeSreen||isMediumSreen?Text(
                  'GUARDAR ',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ):
                Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
