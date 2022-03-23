class VoterModel {

  String id;
  String name;
  String lastName;
  String dni;
  String email;
  String function;
  bool selected;

  VoterModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.function,
    this.selected = false
  });

  factory VoterModel.fromJson(Map<String,dynamic> json) {
    return VoterModel(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      dni: json['dni'],
      email: json['email'],
      function: json['function']
    );
  }

  @override
  String toString() {
    return '{id: $id, name: $name, last_name: $lastName, dni: $dni, email: $email, function: $function}';
  }
}

class VoterListModel {

  final List<VoterModel> voters;

  VoterListModel({required this.voters});

  factory VoterListModel.fromJson(List<dynamic> json) {
    List<VoterModel> voters = [];
    voters = json.map((i) => VoterModel.fromJson(i)).toList();
    return VoterListModel(voters: voters);
  }

  @override
  String toString() {
    return '{voters: $voters}';
  }
}