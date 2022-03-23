import 'dart:convert';
import 'dart:io';

import 'package:e_voting/src/models/candidate.model.dart';
import 'package:e_voting/src/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:e_voting/src/models/voter.model.dart';
import 'package:e_voting/src/utilities/responsive.dart';
import 'package:e_voting/src/views/components/title.view.dart';

class CandidateNewView extends StatefulWidget {
  const CandidateNewView({Key? key}) : super(key: key);

  @override
  _CandidateNewViewState createState() => _CandidateNewViewState();
}

class _CandidateNewViewState extends State<CandidateNewView> {

  //late File _image;
  late String bs64;
  late bool isLargeSreen;
  late bool isMediumSreen;
  late VoterModel voter;
  static List<VoterModel> voters = Cosntants.voters;

  Widget _chilContainer = Icon(
    Icons.add_photo_alternate_outlined,
    color: Colors.white,
    size: 150.0,
  );

  final picker = ImagePicker();
  //final _formKey = GlobalKey<FormState>();
  TextEditingController _position = TextEditingController();

  Future _openGallery() async {
    var picture = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50
    );
    if (picture != null) {
      if (kIsWeb) {
        setState(() {
          Image img = Image.network(picture.path);
          print(img.toString());
          _chilContainer = img;
          // final bytes = file.readAsBytesSync();
          // bs64 = base64Encode(bytes);
          // print(bs64);
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLargeSreen = Responsive.isLargeScreen(context);
    isMediumSreen = Responsive.isMediumScreen(context);
    voters = Cosntants.voters;
    voter = voters[0];
  }

  DropdownButton<VoterModel> selcVoter() {
    return DropdownButton<VoterModel>(
      value: voter,
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
            voter = value;
            print(voter);
          }
        });
      },
      items: voters.map<DropdownMenuItem<VoterModel>>((e) {
        return DropdownMenuItem<VoterModel>(
          value: e,
          child: Text('${e.id} | ${e.name} ${e.lastName}'),
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
      body: ListView(
        children: [
          SizedBox(height: 64.0),
          Title1View(
            title: 'Nuevo candidato',
            isLargeSreen: isLargeSreen,
            isMediumSreen: isMediumSreen,
          ),
          SizedBox(height: 64.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width/3,
                child: TextFormField(
                  controller: _position,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Cargo por el que participa',
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
                CandidateModel candidate = CandidateModel(
                  id: '001',
                  position: _position.text,
                  photo: 'photo',
                  voter: voter
                );
                Cosntants.candidates.add(candidate);
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
      ),
    );
  }
}
