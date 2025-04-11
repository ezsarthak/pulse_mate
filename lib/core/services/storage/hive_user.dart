import 'package:hive/hive.dart';
import 'package:pulse_mate/data/models/user_model.dart';

part 'hive_user.g.dart'; // this triggers code generation

@HiveType(typeId: 0)
class HiveUser extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String age;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String location;

  @HiveField(6)
  final List<String> interests;

  @HiveField(7)
  final String? iat;

  @HiveField(8)
  final String? imgUrl;

  @HiveField(9)
  final String? bio;
  @HiveField(10)
  final String? about;

  HiveUser({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    required this.location,
    required this.interests,
    this.bio,
    this.about,
    this.iat,
    this.imgUrl,
  });

  User toUser() {
    return User(
      id: id,
      email: email,
      name: name,
      age: age,
      gender: gender,
      location: location,
      interests: interests,
      iat: iat,
    );
  }
}
