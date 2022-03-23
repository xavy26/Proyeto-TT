import 'package:e_voting/src/utilities/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultsItem extends StatelessWidget {
  const ResultsItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(Responsive.isLargeScreen(context) ? 24.0 : 16.0),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Eleccion miembros del OCS',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: Responsive.isLargeScreen(context) ? 32.0 : 16.0),
          Text(
            'El partido ganandor es:',
            style: TextStyle(fontSize: 15.0),
          ),
          Text(
            'Transformación Universitaria',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Responsive.isLargeScreen(context) ? 16.0 : 8.0),
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: DecorationImage(
                      image: AssetImage('assets/images/tu.png'))),
            ),
          ),
          SizedBox(height: 16.0),
          Text('Con 155 votos'),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: 'Ver detalles');
            },
            child: Text(
              'Más detalles',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
