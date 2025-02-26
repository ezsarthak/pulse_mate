import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
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
                      textName: "My Email",
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
              // appTextFormField(
              //   textEditingController: _nameController,
              //   hint: 'Enter your name',
              //   label: 'Name',
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your email';
              //     }
              //     return null;
              //   },
              //   appDimensions: appDimension,
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.02,
              // ),
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
                    if (_formKey.currentState!.validate()) {}
                    // Navigator.pushNamed(context, '/signupFlow');
                    // String consoleLog = await AuthService().signIn(
                    //     _emailController.text,
                    //     _passwordController.text,
                    //     _nameController.text);
                    // debugPrint(consoleLog);
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
