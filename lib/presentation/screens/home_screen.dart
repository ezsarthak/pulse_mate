import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mate/core/services/auth_service.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/data/models/profile.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:pulse_mate/presentation/screens/like_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserSimplePrefs simplePrefs = UserSimplePrefs();
  final HomeCarouselGetxController carouselSliderIndex =
      Get.put(HomeCarouselGetxController());
  String? token;
  late Future<User> userToget;
  late Future<List<Profile>> profileList;
  @override
  void initState() {
    userToget = HomeScreenService().getUser();
    profileList = HomeScreenService.getData();
    super.initState();
  }




  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController1 = ScrollController();


  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            profileList.whenComplete(
                () => Future.delayed(const Duration(milliseconds: 300))),
            userToget.whenComplete(
                () => Future.delayed(const Duration(milliseconds: 300))),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<Profile> profiles = snapshot.data![0];
              User user = snapshot.data![1];
              List<String> imgList = [
                profiles.elementAt(0).profilePictures,
                profiles.elementAt(1).profilePictures,
                profiles.elementAt(2).profilePictures,
                profiles.elementAt(3).profilePictures,
                profiles.elementAt(4).profilePictures,
              ];
              int currentIndex = imgList.length - 1;
              debugPrint(snapshot.data.toString());
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Center(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: appText(
                                textName: "Discover",
                                textStyle: TextStyle(
                                  fontFamily: AppConstants.appFont,
                                  fontSize: appDimension.h3,
                                  fontWeight: Dimensions.fontBold,
                                  color: AppColors.black,
                                ))),
                      ),
                      GestureDetector(
                          onTap: () => AuthService().logOut(context),
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: appText(
                                  textName: user.name,
                                  textStyle: TextStyle(
                                    fontFamily: AppConstants.appFont,
                                    fontSize: appDimension.h7,
                                    fontWeight: Dimensions.fontBold,
                                    color: AppColors.black,
                                  )))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),

                      /// Slider
                      Swiper(
                        duration: 200,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      imgList.elementAt(index),
                                    ))),
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: const Radius.circular(16),
                                bottomLeft: const Radius.circular(16),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  height: (MediaQuery.of(context).size.width *
                                          0.75) *
                                      0.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: const Radius.circular(16),
                                        bottomLeft: const Radius.circular(16),
                                      ),
                                      color: Colors.grey.shade200
                                          .withValues(alpha: 0.5)),
                                  child: Center(
                                    child: Text(profiles.elementAt(index).name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: imgList.length,
                        index: imgList.length - 1,
                        axisDirection: AxisDirection.left,
                        loop: false,
                        itemWidth: MediaQuery.of(context).size.width * 0.75,
                        itemHeight: MediaQuery.of(context).size.width * 0.85,
                        layout: SwiperLayout.STACK,
                        onIndexChanged: (int newIndex) {
                          carouselSliderIndex.change(newIndex);
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Obx(
                        () => AnimatedSmoothIndicator(
                          activeIndex: carouselSliderIndex.ind.value,
                          count: imgList.length,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 200),
                          effect: WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            spacing: 16,
                            dotColor: AppColors.black.withValues(alpha: 0.1),
                            activeDotColor: AppColors.red,
                            type: WormType.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class HomeCarouselGetxController extends GetxController {
  var ind = 4.obs;
  change(int newIndex) {
    ind.value = newIndex;
  }
}
