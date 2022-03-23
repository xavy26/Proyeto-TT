import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:e_voting/src/views/home.view.dart';
import 'package:e_voting/src/views/vote.view.dart';
import 'package:e_voting/src/views/login.view.dart';
import 'package:e_voting/src/views/voter/new.view.dart';
import 'package:e_voting/src/views/voter/list.view.dart';
import 'package:e_voting/src/views/candidate/new.view.dart';
import 'package:e_voting/src/views/candidate/list.view.dart';
import 'package:e_voting/src/views/election/new.view.dart';
import 'package:e_voting/src/views/election/list.view.dart';
import 'package:e_voting/src/views/politic_party/new.view.dart';
import 'package:e_voting/src/views/politic_party/list.view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "e-Voting",
      home: HomeView(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', '')
      ],
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0C355B),
          onPrimary: Colors.white,
          secondary: Color(0xFF36AB2B),
          onSecondary: Theme.of(context).colorScheme.onSecondary,
          error: Theme.of(context).colorScheme.error,
          onError: Theme.of(context).colorScheme.onError,
          background: Theme.of(context).colorScheme.background,
          onBackground: Theme.of(context).colorScheme.onBackground,
          surface: Theme.of(context).colorScheme.surface,
          onSurface: Theme.of(context).colorScheme.onSurface
        ),
        textTheme: TextTheme(
          headline5: TextStyle(
            color: Color(0xFF0C355B)
          ),
          headline6: TextStyle(
            color: Color(0xFF0C355B),
            fontWeight: FontWeight.bold
          )
        )
      ),
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomeView(),
        '/login': (context) => LoginView(),
        '/vote': (context) => VoteView(),
        '/voter/new': (context) => VoterNewView(),
        '/voter/list': (context) => VoterListView(),
        '/election/new': (context) => ElectionNewView(),
        '/election/list': (context) => ElectionListView(),
        '/candidate/new': (context) => CandidateNewView(),
        '/candidate/list': (context) => CandidateListView(),
        '/politic_party/new': (context) => PoliticNewView(),
        '/politic_party/list': (context) => PoliticListView(),
      },
    );
  }
}
