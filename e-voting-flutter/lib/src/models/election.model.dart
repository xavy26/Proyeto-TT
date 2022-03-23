class ElectionModel {

  final String id;
  final String name;
  final String desc;
  final String dateStart;
  final String dateEnd;
  bool active;
  bool selected;

  ElectionModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.dateStart,
    required this.dateEnd,
    this.active = true,
    this.selected = false
  });

  factory ElectionModel.fromJson(Map<String,dynamic> json) {
    return ElectionModel(
      id: json['id'],
      name: json['id'],
      desc: json['id'],
      dateStart: json['id'],
      dateEnd: json['id']
    );
  }

  @override
  String toString() {
    return '{id: $id, name: $name, desc: $desc, dateStart: $dateStart, dateEnd: $dateEnd}';
  }
}

class ElectionListModel {

  final List<ElectionModel> elections;

  ElectionListModel({required this.elections});

  factory ElectionListModel.fromJson(List<dynamic> json) {
    List<ElectionModel> elections = [];
    elections = json.map((e) => ElectionModel.fromJson(e)).toList();
    return ElectionListModel(elections: elections);
  }

  @override
  String toString() {
    return '{elections: $elections}';
  }
}