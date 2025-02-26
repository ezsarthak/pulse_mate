import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/presentation/view_model/welcome_viewmodel.dart';
import 'package:pulse_mate/widgets/app_button.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselSliderController carouselSliderController =
        CarouselSliderController();
    final CarouselGetxController carouselSliderIndex =
        Get.put(CarouselGetxController());
    List<String> imgList = [
      "assets/welcome_screen/girl1.png",
      "assets/welcome_screen/girl2.png",
      "assets/welcome_screen/girl3.png",
    ];
    List<String> subTexts = [
      "Users going through a vetting process to\nensure you never match with bots.",
      "We match you with people that have a\nlarge array of similar interests.",
      "Sign up today and enjoy the first month\nof premium benefits on us."
    ];
    List<String> titleTexts = ["Algorithm", "Matches", "Premium"];
    final Dimensions appDimension = Dimensions(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Padding(
          padding: EdgeInsets.only(top: appDimension.topPadding),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              /// Slider
              buildCarousel(
                  carouselSliderController: carouselSliderController,
                  imgList: imgList,
                  carouselSliderIndex: carouselSliderIndex,
                  height: MediaQuery.of(context).size.height * 0.45),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Obx(() => Column(
                    children: [
                      /// Title Text
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: appText(
                              textName:
                                  titleTexts[carouselSliderIndex.ind.value],
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h3,
                                fontWeight: Dimensions.fontBold,
                                color: AppColors.red,
                              ))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      /// Sub Des Text
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: appText(
                              textName: subTexts[carouselSliderIndex.ind.value],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h6,
                                fontWeight: Dimensions.fontRegular,
                                color: AppColors.black,
                              ))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),

                      /// Dots Indicator
                      buildDotsIndicator(
                          carouselSliderIndex: carouselSliderIndex),
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),

              /// Create acc Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: appButton(
                    height: MediaQuery.of(context).size.height * 0.07,
                    fontSize: appDimension.h5,
                    text: "Create an account",
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              /// Already Have acc sign in?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appText(
                      textName: "Already have an account? ",
                      textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontWeight: Dimensions.fontRegular,
                          color: AppColors.black,
                          fontSize: appDimension.h6)),
                  appText(
                      textName: "Sign in",
                      textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontWeight: Dimensions.fontRegular,
                          color: AppColors.red,
                          fontSize: appDimension.h6)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
