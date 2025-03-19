import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/app_icons.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/core/utils/snackbar.dart';
import 'package:pulse_mate/widgets/app_button.dart';
import 'package:pulse_mate/widgets/app_text.dart';
import 'package:pulse_mate/widgets/app_textfield.dart';
import '../../core/services/auth_service.dart';

class SignupFlow extends StatefulWidget {
  const SignupFlow({super.key});

  @override
  State<SignupFlow> createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String date = "Choose birthday date";
  DateTime selectedDate = DateTime(2005, 1, 1);
  int age = DateTime.now().year;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                /// Text
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: appText(
                        textName: "Create Account",
                        textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontSize: appDimension.h1,
                          fontWeight: Dimensions.fontBold,
                          color: AppColors.black,
                        ))),
                appText(
                    textName:
                        "Please enter your valid email id. Create at least 6 length password to create your account.",
                    maxLines: 2,
                    textStyle: TextStyle(
                      fontFamily: AppConstants.appFont,
                      fontSize: appDimension.h6,
                      fontWeight: Dimensions.fontRegular,
                      color: AppColors.black.withValues(alpha: 0.7),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                appTextFormField(
                  textEditingController: _nameController,
                  hint: 'Enter your name',
                  label: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  appDimensions: appDimension,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                appTextFormField(
                  textEditingController: _emailController,
                  hint: 'Enter your email',
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  appDimensions: appDimension,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                appTextFormField(
                  textEditingController: _passwordController,
                  hint: 'Enter your password',
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password length should be at least 6';
                    }
                    return null;
                  },
                  appDimensions: appDimension,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                appTextFormField(
                  textEditingController: _confirmPasswordController,
                  obscureText: true,
                  hint: 'Confirm your password',
                  label: 'Confirm password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Password not matched to confirm password';
                    }
                    if (value.length < 6) {
                      return 'Password length should be at least 6';
                    }
                    return null;
                  },
                  appDimensions: appDimension,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    BottomPicker.date(
                      // titlePadding:
                      // EdgeInsets.only(top: appDimensions.mediumSpace),
                      pickerTitle: appText(
                          textName: "Select DOB",
                          textStyle: TextStyle(
                            fontFamily: AppConstants.appFont,
                            fontSize: appDimension.h4,
                            fontWeight: Dimensions.fontBold,
                            color: AppColors.red,
                          )),
                      dateOrder: DatePickerDateOrder.dmy,
                      initialDateTime: selectedDate,
                      maxDateTime: DateTime(DateTime.now().year),
                      minDateTime: DateTime(1980),
                      pickerTextStyle: TextStyle(
                        color: AppColors.black,
                        fontWeight: Dimensions.fontRegular,
                        fontSize: appDimension.h5,
                      ),
                      buttonWidth: 256,
                      buttonPadding: 12,
                      buttonStyle: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      buttonContent: Center(
                        child: appText(
                            textName: "Confirm",
                            textStyle: TextStyle(
                              fontFamily: AppConstants.appFont,
                              fontSize: appDimension.h4,
                              fontWeight: Dimensions.fontBold,
                              color: AppColors.white,
                            )),
                      ),
                      onSubmit: (index) {
                        setState(() {
                          String day = index.toString().substring(8, 10);
                          String month = index.toString().substring(5, 7);
                          String year = index.toString().substring(0, 4);
                          date = "$day-$month-$year";
                          final DateTime dob = DateTime(int.parse(year),
                              int.parse(month), int.parse(day));
                          selectedDate = dob;
                          final DateTime today = DateTime.now();

                          age = today.year - dob.year;

                          // Check if the birthday has occurred this year
                          if (today.month < dob.month ||
                              (today.month == dob.month &&
                                  today.day < dob.day)) {
                            age--;
                          }
                          print(age);
                        });
                      },
                      bottomPickerTheme: BottomPickerTheme.plumPlate,
                    ).show(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                        color: AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(AppIcons.calender),
                          color: AppColors.red,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        appText(
                            textName: date,
                            textStyle: TextStyle(
                              fontFamily: AppConstants.appFont,
                              fontSize: appDimension.h6,
                              fontWeight: Dimensions.fontBold,
                              color: AppColors.red,
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),

                /// Continue Button
                appButton(
                    height: MediaQuery.of(context).size.height * 0.07,
                    fontSize: appDimension.h5,
                    text: "Continue",
                    onTap: () async {
                      if (age < 18) {
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
                            textName: "Age 18+ Required",
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
                     
                      } else {
                        if (_formKey.currentState!.validate() && age > 18) {
                          try {
                            String jwt = await AuthService().signUp(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                                age.toString());
                            final info = JWT.decode(jwt);
                            debugPrint(info.payload.toString());
                          } catch (e) {
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
                                  textName: e.toString().substring(11),
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
                          }
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
