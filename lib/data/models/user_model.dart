import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String email;
  final String name;
  final String age;
  final String gender;
  final String location;
  final List<String> interests;
  final String? iat;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.interests,
    this.iat,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    age: json["age"],
    gender: json["gender"],
    location: json["location"],
    interests: List<String>.from(json["interests"].map((x) => x)),
    iat: json.containsKey("iat") ? json["iat"] : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "age": age,
    "gender": gender,
    "location": location,
    "interests": List<dynamic>.from(interests.map((x) => x)),
    if (iat != null) "iat": iat,
  };
}
