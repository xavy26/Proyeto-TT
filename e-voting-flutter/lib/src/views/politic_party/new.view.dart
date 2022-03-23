//import 'dart:io';

import 'package:e_voting/src/views/components/title.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/responsive.dart';

class PoliticNewView extends StatefulWidget {
  const PoliticNewView({Key? key}) : super(key: key);

  @override
  _PoliticNewViewState createState() => _PoliticNewViewState();
}

class _PoliticNewViewState extends State<PoliticNewView> {

  //late File _image;
  late String bs64;
  late bool isLargeSreen;
  late bool isMediumSreen;

  Widget _chilContainer = Icon(
    Icons.add_photo_alternate_outlined,
    color: Colors.white,
    size: 150.0,
  );

  final picker = ImagePicker();
  //final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();

  Future _openGallery() async {
    var picture = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );
    if (picture != null) {
      print(picture.path.toString());
      if (kIsWeb) {
        setState(() {
          _chilContainer = Image.network(picture.path);
        });
      }
    }
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('E-Voting'),
        ),
        body: ListView(
          children: [
            SizedBox(height: 64.0),
            Title1View(
                title: 'Nuevo partido político',
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width/2.4),
              child: InkWell(
                child: Container(
                  width: size.width/8,
                  height: size.width/7,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                  ),
                  child: _chilContainer,
                ),
                onTap: () {
                  _openGallery();
                },
              ),
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
