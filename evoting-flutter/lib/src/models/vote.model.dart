import 'package:e_voting/src/models/election.model.dart';
import 'package:e_voting/src/models/politic_party.model.dart';
import 'package:e_voting/src/models/voter.model.dart';

class VoteModel {

  final String id;
  final VoterModel autor;
  final ElectionModel election;
  final PoliticPartyModel vote;

  VoteModel({
    required this.id,
    required this.autor,
    required this.election,
    required this.vote,
  });

  factory VoteModel.fromJson(Map<String,dynamic> json) {
    return VoteModel(
      id: json['id'],
      autor: json['autor'],
      election: json['election'],
      vote: json['vote'],
    );
  }

  @override
  String toString() {
    return '{id: $id, autor: $autor, election: $election, vote: $vote}';
  }
}

class VoteListModel {

  final List<VoteModel> votes;

  VoteListModel({required this.votes});

  factory VoteListModel.fromJson(List<dynamic> json) {
    List<VoteModel> votes = [];
    votes = json.map((e) => VoteModel.fromJson(e)).toList();
    return VoteListModel(votes: votes);
  }
}