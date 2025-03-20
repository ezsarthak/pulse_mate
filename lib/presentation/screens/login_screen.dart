import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/auth_service.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/core/utils/snackbar.dart';
import 'package:pulse_mate/widgets/app_button.dart';
import 'package:pulse_mate/widgets/app_text.dart';
import 'package:pulse_mate/widgets/app_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Form(
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
                      textName: "Login Account",
                      textStyle: TextStyle(
                        fontFamily: AppConstants.appFont,
                        fontSize: appDimension.h1,
                        fontWeight: Dimensions.fontBold,
                        color: AppColors.black,
                      ))),
              appText(
                  textName:
                      "Please enter your email id and password to login back to your account",
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
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              /// Continue Button
              appButton(
                  height: MediaQuery.of(context).size.height * 0.07,
                  fontSize: appDimension.h5,
                  text: "Continue",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        String jwt = await AuthService().login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        final info = JWT.decode(jwt);
                        debugPrint(info.payload.toString());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        final snackbar = SnackBar(
                          backgroundColor:
                              AppColors.secondary.withValues(alpha: 0.5),
                          // padding: const EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: appText(
                              textName: e.toString().substring(11),
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h5,
                                fontWeight: Dimensions.fontRegular,
                                color: AppColors.white,
                              )),
                          elevation: 0,

                          behavior: SnackBarBehavior.floating,
                        );
                        showSnackbar(context, snackbar);
                      }
                    }
                  }),
            ],
          ),
        ),
                ),
              ),
      ),
    );
  }
}
