import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:pulse_mate/core/services/chat_service.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/app_icons.dart';
import 'package:pulse_mate/core/utils/app_loader.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/core/utils/extensions.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:pulse_mate/presentation/screens/chat_details_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<User>> friendsList;
  late Future<List<User>> currentFriendsFuture;
  bool hasLoadedFriends = false;

  List<User> currentFriends = [];
  final LoadingGetxController loadingGetxController =
      Get.put(LoadingGetxController());
  late User user;
  Future<void> getUser() async {
    user = await HomeScreenService().getUser();
  }

  @override
  void initState() {
    friendsList = ChatService().getFriends();
    getUser();
    super.initState();
  }

  Future<List<User>> _loadFriends(AsyncSnapshot snapshot) async {
    // 1. Load existing Hive users

    // 2. Add new unique users from snapshot to Hive
    ChatService().saveUniqueChatUsersFromSnapshot(snapshot);

    // 3. Re-fetch updated Hive list after new users are added
    final updatedHiveFriends = await ChatService().getChatUserList();
    log(updatedHiveFriends.elementAt(0).email);
    final List<User> updatedUsers =
        updatedHiveFriends.map((e) => e.toUser()).toList();

    // 4. Update UI state
    log(updatedUsers.elementAt(0).email);
    setState(() {
      currentFriends = updatedUsers;
    });

    return updatedUsers;
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.bg,
            elevation: 0,
            title: FittedBox(
                fit: BoxFit.scaleDown,
                child: appText(
                    textName: "Messages",
                    textStyle: TextStyle(
                      fontFamily: AppConstants.appFont,
                      fontSize: appDimension.h1,
                      fontWeight: Dimensions.fontBold,
                      color: AppColors.black,
                    ))),
            actions: [
              Container(
                height: 52,
                width: 52,
                margin: EdgeInsets.only(right: 12, top: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: AssetImage(AppIcons.message)),
                    border: Border.all(color: AppColors.border, width: 1)),
              )
            ],
          ),
          backgroundColor: AppColors.bg,
          body: FutureBuilder<List<User>>(
              future: friendsList.whenComplete(
                  () => Future.delayed(const Duration(milliseconds: 700))),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  if (!hasLoadedFriends) {
                    hasLoadedFriends = true;
                    _loadFriends(snapshot).then((_) {
                      loadingGetxController.toggle();
                    });
                  }
                  currentFriends.isNotEmpty
                      ? log(currentFriends.elementAt(0).email)
                      : null;
                  return Obx(
                    () => loadingGetxController.isLoading.value
                        ? AppLoader()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: ListView.builder(
                                itemCount: currentFriends.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatDetailsScreen(
                                                    sender: user.email,
                                                    receiver: currentFriends
                                                        .elementAt(index)
                                                        .email,
                                                    chatName: currentFriends
                                                        .elementAt(index)
                                                        .name,
                                                    user: currentFriends
                                                        .elementAt(index)
                                                        .toHiveUser,
                                                  )));
                                    },
                                    child: ListTile(
                                      title: appText(
                                        textName: currentFriends
                                            .elementAt(index)
                                            .name
                                            .capitalizeFirstOfEach,
                                        textStyle: TextStyle(
                                          fontFamily: AppConstants.appFont,
                                          fontSize: appDimension.h6,
                                          fontWeight: Dimensions.fontBold,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      subtitle: appText(
                                        textName: "Tap to Chat",
                                        textStyle: TextStyle(
                                          fontFamily: AppConstants.appFont,
                                          fontSize: appDimension.h7,
                                          fontWeight: Dimensions.fontRegular,
                                          color: AppColors.black
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      trailing: Image.asset(
                                        AppIcons.next,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  );
                } else {
                  return Center(
                    child: AppLoader(),
                  );
                }
              })),
    );
  }
}

class LoadingGetxController extends GetxController {
  var isLoading = true.obs;
  toggle() {
    isLoading.value = false;
  }
}
