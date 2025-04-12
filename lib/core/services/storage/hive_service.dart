import 'package:hive/hive.dart';

import 'hive_user.dart';

class HiveService {
  final Box<HiveUser> box = Hive.box<HiveUser>('matchesBox');

// Get all users
  List<HiveUser> getAllHiveUsers() {
    final box = Hive.box<HiveUser>('matchesBox');
    return box.values.toList();
  }

  Future<void> addSingleHiveUser(HiveUser user) async {
    final box = Hive.box<HiveUser>('matchesBox');
    final existingEmails = box.values.map((u) => u.email).toSet();

    if (!existingEmails.contains(user.email)) {
      await box.add(user);
    }
  }

  void deleteHive() async {
    await Hive.deleteFromDisk();
  }
}
