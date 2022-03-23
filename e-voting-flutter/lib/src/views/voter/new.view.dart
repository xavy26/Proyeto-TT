import 'package:e_voting/src/models/voter.model.dart';
import 'package:e_voting/src/utilities/constants.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/utilities/utilities.dart';
import 'package:e_voting/src/views/components/title.view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VoterNewView extends StatefulWidget {
  const VoterNewView({Key? key}) : super(key: key);

  @override
  _VoterNewViewState createState() => _VoterNewViewState();
}

class _VoterNewViewState extends State<VoterNewView> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  final _form = GlobalKey<FormState>();

  bool selected = false;
  bool selected1 = false;
  String selc = 'Estudiante';
  TextEditingController _name = TextEditingController();
  TextEditingController _last = TextEditingController();
  TextEditingController _dni = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _function = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  DropdownButton<String> selcVoter() {
    return DropdownButton<String>(
      value: selc,
      isExpanded: true,
      hint: Text(
        'Seleccione',
        style: TextStyle(
            color: Colors.grey
        ),
      ),
      underline: Container(
        color: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            selc = value;
          }
        });
      },
      items: ['Estudiante','Docente','Administrativo','Servicio'].map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text('$e'),
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('E-Voting'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: [
            SizedBox(height: 32.0),
            Title1View(
              title: 'Nuevo votante',
              isLargeSreen: isLargeSreen,
              isMediumSreen: isMediumSreen
            ),
            SizedBox(height: 64.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width/5,
                  child: TextFormField(
                    controller: _name,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    validator: (input) => Utilities.valNames(input.toString()),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
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
                  width: size.width/5,
                  child: TextFormField(
                    controller: _last,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    validator: (input) => Utilities.valNames(input.toString()),
                    decoration: InputDecoration(
                      labelText: 'Apellido',
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
                  width: size.width/5,
                  child: TextFormField(
                    maxLength: 10,
                    controller: _dni,
                    keyboardType: TextInputType.number,
                    validator: (nui) => Utilities.valDNI(nui.toString()),
                    decoration: InputDecoration(
                      labelText: 'Cédula',
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
                  width: size.width/5,
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Utilities.validateEmail(value.toString()),
                    decoration: InputDecoration(
                      labelText: 'Correo',
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
            SizedBox(height: 32.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width/2.5),
              child: Container(
                width: size.width/3,
                padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                        color: Colors.black45
                    )
                ),
                child: selcVoter(),
              ),
            ),
            SizedBox(height: 64.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width/2.5,
                vertical: 16.0
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    VoterModel voter = VoterModel(
                      id: _dni.text,
                      name: _name.text,
                      lastName: _last.text,
                      dni: _dni.text,
                      email: _email.text,
                      function: _function.text
                    );
                    setState(() {
                      Cosntants.voters.add(voter);
                    });
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Verifique los compos erroneos',
                        toastLength: Toast.LENGTH_LONG,
                        webBgColor: "linear-gradient(to right, #000000, #000000)"
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    'GUARDAR ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
