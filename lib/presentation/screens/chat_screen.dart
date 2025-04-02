import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/chat_service.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/app_icons.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:pulse_mate/presentation/screens/chat_details_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<User>> friendsList;late User user;
  Future<void> getUser() async {
    user= await HomeScreenService().getUser();
  }
  @override
  void initState() {
    friendsList = ChatService().getFriends();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
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
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: AssetImage(AppIcons.message)),
                    border: Border.all(color: AppColors.border, width: 1)),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: FutureBuilder<List<User>>(
              future: friendsList.whenComplete(
                  () => Future.delayed(const Duration(milliseconds: 700))),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatDetailsScreen(
                                          sender: user.email,
                                          receiver: snapshot.data!
                                              .elementAt(index)
                                              .email)));
                            },
                            child: ListTile(
                              title: appText(
                                textName: snapshot.data!.elementAt(index).name,
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
                                  color: AppColors.black.withValues(alpha: 0.6),
                                ),
                              ),
                              trailing: Image.asset(
                                AppIcons.next,
                                width: MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
