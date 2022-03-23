import 'package:e_voting/src/models/election.model.dart';
import 'package:e_voting/src/models/item_result.model.dart';
import 'package:e_voting/src/models/politic_party.model.dart';

class ResultModel {

  final String id;
  final int nroVotes;
  final ElectionModel election;
  final ItemResultListModel results;
  final PoliticPartyModel winner;
  
  ResultModel({
    required this.id,
    required this.nroVotes,
    required this.election,
    required this.results,
    required this.winner
  });
  
  factory ResultModel.fromJson(Map<String,dynamic> json) {
    return ResultModel(
      id: json['id'],
      nroVotes: json['nro_votes'],
      election: ElectionModel.fromJson(json['election']),
      results: ItemResultListModel.fromJson(json['results']),
      winner: PoliticPartyModel.fromJson(json['winner']),
    );
  }

  @override
  String toString() {
    return '{id: $id, nroVotes: $nroVotes, election: $election, results: $results, winner: $winner}';
  }
}

class ResultListModel {

  final List<ResultModel> results;

  ResultListModel({required this.results});

  factory ResultListModel.fromJson(List<dynamic> json) {
    List<ResultModel> results = [];
    results = json.map((e) => ResultModel.fromJson(e)).toList();
    return ResultListModel(results: results);
  }

  @override
  String toString() {
    return '{results: $results}';
  }
}