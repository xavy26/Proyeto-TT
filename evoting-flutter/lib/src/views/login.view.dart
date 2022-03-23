import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_voting/src/utilities/constants.dart';
import 'package:e_voting/src/utilities/responsive.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  bool _obscured = true;
  late bool isLargeSreen;
  late bool isMediumSreen;

  void _toggle() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: isLargeSreen?size.width/4:isMediumSreen?size.width/8:16.0
            ),
            children: [
              Text(
                'Ingrese sus datos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary
                    )
                  )
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _pass,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary
                    )
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscured?Icons.visibility_off:Icons.visibility,
                      color: Colors.black45,
                    ),
                    onPressed: _toggle,
                  )
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 64.0,
                    vertical: 16.0
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Cosntants.isLogin = true;
                    Cosntants.isAdmin = true;
                    Fluttertoast.showToast(msg: 'Inicio');
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
                    child: isLargeSreen||isMediumSreen?Text(
                      'INGRESAR',
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
          ),
        )
      ),
    );
  }
}
