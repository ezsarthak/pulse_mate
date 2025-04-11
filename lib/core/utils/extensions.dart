import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/data/models/profile.dart';
import 'package:pulse_mate/data/models/user_model.dart';

extension StringExtension on String {
  String get inCaps =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  String get capitalizeFirstOfEach =>
      split(" ").map((str) => str.inCaps).join(" ");
}

extension HiveConversion on User {
  HiveUser get toHiveUser => HiveUser(
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

extension HiveConversionTwo on Profile {
  HiveUser get toHiveUserUsingProfile => HiveUser(
      id: id.toString(),
      email: name,
      name: name,
      age: age.toString(),
      gender: gender,
      bio: bio,
      about: about,
      location: location,
      interests: interests,
      imgUrl: profilePictures);
}

extension HiveConversionThree on HiveUser {
  Profile get toProfileUsingHiveUser => Profile(
        id: int.parse(id),
        name: name,
        age: int.parse(age),
        gender: gender,
        location: location,
        interests: interests,
        bio: bio!,
        about: about!,
        profilePictures: imgUrl!,
      );
}
