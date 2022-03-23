import 'package:e_voting/src/models/candidate.model.dart';

class PoliticPartyModel {

  final String id;
  final String name;
  final String desc;
  final String logo;
  final List<CandidateModel> candidates;
  bool active;
  bool selected;

  PoliticPartyModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.logo,
    required this.candidates,
    this.active = true,
    this.selected = false,
  });

  factory PoliticPartyModel.fromJson(Map<String,dynamic> json) {
    return PoliticPartyModel(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      logo: json['logo'],
      candidates: CandidateListModel.fromJson(json['candidates']).candidates
    );
  }

  @override
  String toString() {
    return '{id: $id, name: $name, desc: $desc, logo: $logo, candidates: $candidates}';
  }
}

class PoliticPartyListModel {

  final List<PoliticPartyModel> politicParties;

  PoliticPartyListModel({required this.politicParties});

  factory PoliticPartyListModel.fromJson(List<dynamic> json) {
    List<PoliticPartyModel> politicParties = [];
    politicParties = json.map((e) => PoliticPartyModel.fromJson(e)).toList();
    return PoliticPartyListModel(politicParties: politicParties);
  }

  @override
  String toString() {
    return '{politicParties: $politicParties}';
  }
}