import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:pulse_mate/core/services/auth_service.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/services/storage/hive_service.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/app_loader.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/core/utils/extensions.dart';
import 'package:pulse_mate/core/utils/screen_overlay.dart';
import 'package:pulse_mate/data/models/profile.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:pulse_mate/presentation/screens/chat_details_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';
import 'package:pulse_mate/widgets/match_overlay.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pulse_mate/core/utils/extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserSimplePrefs simplePrefs = UserSimplePrefs();
  final HomeScreenGetxController carouselSliderIndex =
      Get.put(HomeScreenGetxController());
  final CardSwiperController swiperController = CardSwiperController();
  String? token;
  late Future<User> userToget;
  late Future<List<Profile>> profileList;
  @override
  void initState() {
    userToget = HomeScreenService().getUser();
    profileList = HomeScreenService.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
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

              carouselSliderIndex.loadNextImages(profiles);

              void swipedRight(bool isButton) {
                if (isButton) {
                  swiperController.swipe(CardSwiperDirection.right);
                } else {
                  List<String> userInterests = user.interests;
                  List<String> profileInterests = carouselSliderIndex
                      .imgList.value
                      .elementAt(carouselSliderIndex.swiperIndex.value)
                      .interests;

                  Set<String> commonInterests = userInterests
                      .map((e) => e.toLowerCase())
                      .toSet()
                      .intersection(
                        profileInterests.map((e) => e.toLowerCase()).toSet(),
                      );
                  log(carouselSliderIndex.imgList.value
                      .elementAt(carouselSliderIndex.swiperIndex.value)
                      .name);
                  if (commonInterests.length > 1) {
                    HiveService().addSingleHiveUser(carouselSliderIndex
                        .imgList
                        .value[carouselSliderIndex.swiperIndex.value]
                        .toHiveUserUsingProfile);
                    // They have at least two common interest
                    showAnimatedOverlay(
                      context: context,
                      content: MatchOverlay(
                        firstUserImage: carouselSliderIndex
                            .imgList
                            .value[carouselSliderIndex.swiperIndex.value]
                            .profilePictures,
                        secondUserImage: carouselSliderIndex
                            .imgList
                            .value[carouselSliderIndex.swiperIndex.value]
                            .profilePictures,
                        onSayHello: () {
                          // Handle say hello action

                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatDetailsScreen(
                                        sender: user.email,
                                        receiver: carouselSliderIndex
                                            .imgList
                                            .value[carouselSliderIndex
                                                    .swiperIndex.value -
                                                1]
                                            .name,
                                        chatName: carouselSliderIndex
                                            .imgList
                                            .value[carouselSliderIndex
                                                    .swiperIndex.value -
                                                1]
                                            .name,
                                        user: carouselSliderIndex
                                            .imgList
                                            .value[carouselSliderIndex
                                                    .swiperIndex.value -
                                                1]
                                            .toHiveUserUsingProfile,
                                      )));
                        },
                        onKeepSwiping: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                }
              }

              void swipedLeft(bool isButton) {
                if (isButton) {
                  swiperController.swipe(CardSwiperDirection.left);
                }
              }

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
                                  fontSize: appDimension.h1,
                                  fontWeight: Dimensions.fontBold,
                                  color: AppColors.black,
                                ))),
                      ),
                      GestureDetector(
                          onTap: () => AuthService().logOut(context),
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: appText(
                                  textName: user.name.capitalizeFirstOfEach,
                                  textStyle: TextStyle(
                                    fontFamily: AppConstants.appFont,
                                    fontSize: appDimension.h5,
                                    fontWeight: Dimensions.fontBold,
                                    color: AppColors.red,
                                  )))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),

                      /// Slider
                      SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: Obx(() {
                          final newProfiles = carouselSliderIndex.imgList;

                          if (newProfiles.isEmpty) {
                            return Center(
                                child: Text("No matches found for you😔"));
                          }
                          return CardSwiper(
                            key: carouselSliderIndex.swiperKey.value,
                            scale: 0,
                            duration: Duration(milliseconds: 300),
                            controller: swiperController,
                            isLoop: false,
                            onEnd: () {
                              carouselSliderIndex.changeSwiperIndex(0);
                              carouselSliderIndex.loadNextImages(profiles);
                            },
                            onSwipe: (int dontKnow, int? newIndex,
                                CardSwiperDirection direction) {
                              if (direction == CardSwiperDirection.right) {
                                swipedRight(false);
                              } else if (direction ==
                                  CardSwiperDirection.left) {
                                swipedLeft(false);
                              }

                              if (newIndex != null) {
                                carouselSliderIndex.changeSwiperIndex(newIndex);
                              }

                              return true;
                            },
                            allowedSwipeDirection:
                                AllowedSwipeDirection.symmetric(
                                    horizontal: true, vertical: false),
                            cardsCount:
                                carouselSliderIndex.imgList.value.length,
                            cardBuilder: (BuildContext context,
                                int index,
                                int horizontalOffsetPercentage,
                                int verticalOffsetPercentage) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      carouselSliderIndex
                                          .imgList[index].profilePictures,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 8.0, sigmaY: 8.0),
                                    child: Container(
                                      height:
                                          (MediaQuery.of(context).size.width) *
                                              0.18,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                        color: Colors.grey.shade200
                                            .withValues(alpha: 0.5),
                                      ),
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.only(left: 8, top: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: appText(
                                                textName: carouselSliderIndex
                                                    .imgList.value[index].name,
                                                textAlign: TextAlign.center,
                                                textStyle: TextStyle(
                                                  fontFamily:
                                                      AppConstants.appFont,
                                                  fontSize: appDimension.h4,
                                                  fontWeight:
                                                      Dimensions.fontBold,
                                                  color: AppColors.black,
                                                )),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: appText(
                                                textName: carouselSliderIndex
                                                    .imgList.value[index].bio,
                                                textAlign: TextAlign.center,
                                                textStyle: TextStyle(
                                                  fontFamily:
                                                      AppConstants.appFont,
                                                  fontSize: appDimension.h7,
                                                  fontWeight:
                                                      Dimensions.fontRegular,
                                                  color: AppColors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Obx(
                        () => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AnimatedSmoothIndicator(
                            activeIndex:
                                carouselSliderIndex.swiperIndex.value.toInt(),
                            count: carouselSliderIndex.imgList.value.length
                                .toInt(),
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 100),
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCircleButton(
                                onTap: () {
                                  swipedLeft(true);
                                },
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.orange,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 20),
                              _buildCircleButton(
                                onTap: () {
                                  swipedRight(true);
                                },
                                backgroundColor: AppColors.red,
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                size: 100,
                              ),
                              const SizedBox(width: 20),
                              _buildCircleButton(
                                onTap: () {
                                  carouselSliderIndex.loadNextImages(profiles);
                                },
                                backgroundColor: Colors.white,
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: AppColors.purple,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: AppLoader(),
              );
            }
          },
        ),
      ),
    );
  }
}

class HomeScreenGetxController extends GetxController {
  var swiperIndex = 0.obs;
  changeSwiperIndex(int newIndex) {
    swiperIndex.value = newIndex;
  }

  RxList<Profile> imgList = <Profile>[].obs;
  static int _currentIndex = 0;

  /// Call this function to load the next 30 images
  var swiperKey = UniqueKey().obs;

  void loadNextImages(List<Profile> profiles) {
    if (profiles.isEmpty) return;

    if (_currentIndex >= profiles.length) {
      _currentIndex = 0;
    }

    int batchSize = 8;
    int end = (_currentIndex + batchSize <= profiles.length)
        ? _currentIndex + batchSize
        : profiles.length;

    imgList.value = profiles.sublist(_currentIndex, end);
    _currentIndex = end;

    // 🔥 force CardSwiper rebuild
    swiperKey.value = UniqueKey();
    swiperIndex.value = 0;
  }
}

Widget _buildCircleButton({
  required VoidCallback onTap,
  required Color backgroundColor,
  required Icon icon,
  double size = 80,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.1),
          blurRadius: 24,
          spreadRadius: 1,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Material(
      color: backgroundColor,
      elevation: 0,
      shape: const CircleBorder(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: icon,
        ),
      ),
    ),
  );
}
