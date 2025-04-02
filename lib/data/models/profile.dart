
// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String bio;
  final String about;
  final List<String> interests;
  final String location;
  final String profilePictures;

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bio,
    required this.about,
    required this.interests,
    required this.location,
    required this.profilePictures,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    name: json["name"],
    age: json["age"],
    gender: json["gender"],
    bio: json["bio"],
    about: json["about"],
    interests: List<String>.from(json["interests"].map((x) => x)),
    location: json["location"],
    profilePictures: json["profilePictures"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "age": age,
    "gender": gender,
    "bio": bio,
    "about": about,
    "interests": List<dynamic>.from(interests.map((x) => x)),
    "location": location,
    "profilePictures": profilePictures,
  };
}
