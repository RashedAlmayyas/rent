class User {
  final int id;
  final String name;
  final String email;
  final String nationalId;

  User({required this.id, required this.name, required this.email, required this.nationalId});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    nationalId: json['national_id'],
  );
}
