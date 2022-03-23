import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:e_voting/src/views/vote.view.dart';
import 'package:e_voting/src/views/login.view.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/voter/list.view.dart';
import 'package:e_voting/src/views/election/list.view.dart';
import 'package:e_voting/src/views/candidate/list.view.dart';
import 'package:e_voting/src/views/components/drawer.view.dart';
import 'package:e_voting/src/views/politic_party/list.view.dart';
import 'package:e_voting/src/views/components/results.view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  late bool isLargeSreen;
  late bool isMediumSreen;

  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
  }

  // Retorna el widget que ira dentro del contenedor, segun el item seleccionado del navegador lateral
  _selectContainer() {
    switch(_index) {
      case 0: //Inicio
        return ResultView();
      case 1: //Sufragar
        return VoteView();
      case 2: //Elecciones
        return ElectionListView();
      case 3: //Partidos Políticos
        return PoliticListView();
      case 4: //Candidatos
        return CandidateListView();
      case 5: //Votantes
        return VoterListView();
      case 6: //Inicio de sesión
        return LoginView();
    }
  }

  void _openUrl() async {
    if (!await launch('https://unl.edu.ec')) throw 'Could not launch https://unl.edu.ec';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('E-Voting'),
        leading: isLargeSreen?Icon(
          Icons.how_to_vote
        ):null,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo_unl_white.png'),
            ),
            onTap: () {
              _openUrl();
            },
          )
        ],
      ),
      drawer: kIsWeb||!Responsive.isSmallScreen(context)?null:DrawerView(),
      body: Container(
        child: Row(
          children: [
            Visibility(
              visible: kIsWeb||!Responsive.isSmallScreen(context),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 64.0),
                    child: NavigationRail(
                      extended: isLargeSreen?true:false,
                      selectedIndex: _index,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _index = index;
                        });
                      },
                      selectedLabelTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                      ),
                      selectedIconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary
                      ),
                      labelType: isLargeSreen?NavigationRailLabelType.none:NavigationRailLabelType.selected,
                      destinations: [
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.home_outlined
                            ),
                            selectedIcon: Icon(
                                Icons.home
                            ),
                            label: Text('Inicio')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.how_to_vote_outlined
                            ),
                            selectedIcon: Icon(
                                Icons.how_to_vote
                            ),
                            label: Text('Sufragar')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.list_alt_outlined
                            ),
                            selectedIcon: Icon(
                                Icons.list_alt
                            ),
                            label: Text('Elecciones')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.list_outlined
                            ),
                            selectedIcon: Icon(
                                Icons.list
                            ),
                            label: Text(isLargeSreen?'Partidos Políticos':'Patidos...')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.person_outline
                            ),
                            selectedIcon: Icon(
                                Icons.person
                            ),
                            label: Text('Candidatos')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.people_outline
                            ),
                            selectedIcon: Icon(
                                Icons.people
                            ),
                            label: Text('Votantes')
                        ),
                        NavigationRailDestination(
                            icon: Icon(
                                Icons.login_outlined
                            ),
                            selectedIcon: Icon(
                                Icons.login
                            ),
                            label: Text(isLargeSreen?'Iniciar Sesión':'Ingresar')
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          isLargeSreen?'assets/images/logo_cis.png':'assets/images/ic_cis.png',
                          fit: BoxFit.fitWidth,
                          width: isLargeSreen?MediaQuery.of(context).size.width/6-8:isMediumSreen?MediaQuery.of(context).size.width/20:MediaQuery.of(context).size.width/15,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            Visibility(
              visible: isLargeSreen,
              child: const VerticalDivider(
                thickness: 1,
                width: 1,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: _selectContainer(),
              )
            )
          ],
        ),
      ),
    );
  }
}
