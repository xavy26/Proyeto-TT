import 'package:e_voting/src/models/politic_party.model.dart';

class ItemResultModel {

  final String id;
  final int nroVotes;
  final PoliticPartyModel politicParty;

  ItemResultModel({
    required this.id,
    required this.nroVotes,
    required this.politicParty
  });

  factory ItemResultModel.fromJson(Map<String,dynamic> json) {
    return ItemResultModel(
      id: json['id'],
      nroVotes: json['nro_votes'],
      politicParty: json['politic_party']
    );
  }

  @override
  String toString() {
    return '{id: $id, nroVotes: $nroVotes, politicParty: $politicParty}';
  }
}

class ItemResultListModel {

  final List<ItemResultModel> itemsResult;

  ItemResultListModel({required this.itemsResult});

  factory ItemResultListModel.fromJson(List<dynamic>  json) {
    List<ItemResultModel> itemsResult = [];
    itemsResult = json.map((e) => ItemResultModel.fromJson(e)).toList();
    return ItemResultListModel(itemsResult: itemsResult);
  }

  @override
  String toString() {
    return '{itemsResult: $itemsResult}';
  }
}