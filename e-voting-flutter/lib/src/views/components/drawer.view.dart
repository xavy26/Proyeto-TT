import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_voting/src/utilities/constants.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {

  var accountName;
  var accountEmail;

  @override
  void initState() {
    super.initState();
    accountName = 'User Name';
    accountEmail = 'user.email@example.com';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Visibility(
              visible: Cosntants.isLogin,
              child: UserAccountsDrawerHeader(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                currentAccountPicture: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/user_desfault.png'),
                      fit: BoxFit.contain
                    )
                  ),
                ),
                accountName: Text(
                  '$accountName',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  '$accountEmail',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

              ),
            ),
            SizedBox(height: Cosntants.isLogin?8.0:64.0),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: Text(
                'Inicio',
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.how_to_vote,
              ),
              title: Text(
                'Sufragar',
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/vote', (route) => false);
              },
            ),
            Divider(height: 16.0),
            ListTile(
              leading: Icon(
                Cosntants.isLogin?Icons.logout:Icons.login,
              ),
              title: Text(
                Cosntants.isLogin?'Cerrar sesión':'Iniciar sesión',
              ),
              onTap: () {
                Fluttertoast.showToast(msg: 'Iniciar sesión');
                Navigator.pushNamed(context, '/login');
              },
            ),
            Expanded(
              child: Container(),
            ),
            Image.asset(
              'assets/images/logo_cis.png',
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
