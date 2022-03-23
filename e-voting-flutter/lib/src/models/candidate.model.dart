import 'package:e_voting/src/models/voter.model.dart';

class CandidateModel {

  String id;
  String position;
  String photo;
  VoterModel voter;

  CandidateModel({
    required this.id,
    required this.position,
    required this.photo,
    required this.voter,
  });

  factory CandidateModel.fromJson(Map<String,dynamic> json) {
    return CandidateModel(
      id: json['id'],
      position: json['position'],
      photo: json['photo'],
      voter: VoterModel.fromJson(json['voter'])
    );
  }

  @override
  String toString() {
    return '{id: $id, position: $position, photo: $photo, voter: $voter}';
  }
}

class CandidateListModel {

  final List<CandidateModel> candidates;

  CandidateListModel({required this.candidates});

  factory CandidateListModel.fromJson(List<dynamic> json) {
    List<CandidateModel> candidates = [];
    candidates = json.map((i) => CandidateModel.fromJson(i)).toList();
    return CandidateListModel(candidates: candidates);
  }

  @override
  String toString() {
    return '{candidates: $candidates}';
  }
}