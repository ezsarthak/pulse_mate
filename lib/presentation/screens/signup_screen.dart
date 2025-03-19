import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/snackbar.dart';
import 'package:pulse_mate/widgets/app_button.dart' show appButton;
import 'package:pulse_mate/widgets/app_text.dart';

import '../../core/utils/dimensions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),

            /// App Logo
            Center(
              child: Image.asset(
                "assets/app_logo.png",
                height: MediaQuery.of(context).size.width * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            /// Text
            FittedBox(
                fit: BoxFit.scaleDown,
                child: appText(
                    textName: "Sign up to continue",
                    textStyle: TextStyle(
                      fontFamily: AppConstants.appFont,
                      fontSize: appDimension.h4,
                      fontWeight: Dimensions.fontBold,
                      color: AppColors.black,
                    ))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            /// Email Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: appButton(
                  height: MediaQuery.of(context).size.height * 0.07,
                  fontSize: appDimension.h5,
                  text: "Continue with email",
                  onTap: () {
                    Navigator.pushNamed(context, '/signupFlow');
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),

            /// Or Sign Up with
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 2,
                  decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: appText(
                        textName: "or sign up with",
                        textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontSize: appDimension.h7,
                          fontWeight: Dimensions.fontRegular,
                          color: AppColors.black,
                        ))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 2,
                  decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12)),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            /// Facebook Google Apple
            GestureDetector(
              onTap: () {
                final snackbar = SnackBar(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                  // padding: const EdgeInsets.all(20),
                  margin:EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  content: appText(
                      textName: "Coming Soon",
                      textStyle: TextStyle(
                        fontFamily: AppConstants.appFont,
                        fontSize: appDimension.h5,
                        fontWeight: Dimensions.fontBold,
                        color: AppColors.white,
                      )
                  ),
                  elevation: 0,

                  behavior: SnackBarBehavior.floating,
                );
                showSnackbar(context, snackbar);

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.18,
                    width: MediaQuery.of(context).size.width * 0.18,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/signup/facebook.png",
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.18,
                    width: MediaQuery.of(context).size.width * 0.18,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/signup/google.png",
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.18,
                    width: MediaQuery.of(context).size.width * 0.18,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/signup/apple.png",
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),

            /// Terms of use and privacy policy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: appText(
                        textName: "Terms of use",
                        textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontSize: appDimension.h6,
                          fontWeight: Dimensions.fontRegular,
                          color: AppColors.red,
                        ))),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: appText(
                        textName: "Privacy Policy",
                        textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontSize: appDimension.h6,
                          fontWeight: Dimensions.fontRegular,
                          color: AppColors.red,
                        ))),
                SizedBox(width: MediaQuery.of(context).size.width * 0.08),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
