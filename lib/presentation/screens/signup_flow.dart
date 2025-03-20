import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final _pageController = PageController(initialPage: 0);
  String date = "Choose birthday date";
  DateTime selectedDate = DateTime(2005, 1, 1);
  int age = DateTime.now().year;
  bool selected = false;
  final List<String> locations = [
    "Pune",
    "Delhi",
    "Bengaluru",
    "Chennai",
    "Hyderabad",
    "Kolkata",
    "Mumbai",
    "Ahmedabad",
    "Bhopal",
    "Noida"
  ];
  String? selectedLocation;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  final Set<String> selectedInterests = {};

  final List<Map<String, dynamic>> interests = [
    {'icon': Icons.camera_alt_outlined, 'label': 'Photography'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
    {'icon': Icons.computer, 'label': 'Coding'},
    {'icon': Icons.sports_soccer_rounded, 'label': 'Sports'},
    {'icon': Icons.business, 'label': 'business'},
    {'icon': Icons.graphic_eq, 'label': 'technology'},
    {'icon': Icons.music_note_outlined, 'label': 'Music'},
    {'icon': Icons.palette_outlined, 'label': 'Art'},
    {'icon': Icons.fitness_center, 'label': 'Fitness'},
    {'icon': Icons.flight_outlined, 'label': 'Travel'},
    {'icon': Icons.history_edu, 'label': 'education'},
    {'icon': Icons.restaurant_outlined, 'label': 'Cooking'},
    {'icon': Icons.people, 'label': 'culture'},
  ];
  @override
  Widget build(BuildContext context) {
    final GenderGetxController genderGetxController =
        Get.put(GenderGetxController());
    final Dimensions appDimension = Dimensions(context);

    List<Widget> pages = [
      /// Create ACC page
      Form(
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
                      maxDateTime: DateTime(DateTime.now().year - 17),
                      minDateTime: DateTime(DateTime.now().year - 30),
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
                          backgroundColor:
                              AppColors.secondary.withValues(alpha: 0.5),
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: appText(
                              textName: "Age 18+ Required",
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h5,
                                fontWeight: Dimensions.fontBold,
                                color: AppColors.white,
                              )),
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                        );
                        showSnackbar(context, snackbar);
                      } else {
                        if (_formKey.currentState!.validate() && age > 18) {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),

      /// Gender and Interest Page
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              /// Text
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0, duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 32,
                        color: AppColors.red,
                      )),
                  SizedBox(
                    width: 12,
                  ),
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: appText(
                          textName: "Profile Details",
                          textStyle: TextStyle(
                            fontFamily: AppConstants.appFont,
                            fontSize: appDimension.h1,
                            fontWeight: Dimensions.fontBold,
                            color: AppColors.black,
                          ))),
                ],
              ),
              appText(
                  textName:
                      "Select Gender, Location and a few of your interests and let everyone know what you're passionate about.",
                  maxLines: 4,
                  textStyle: TextStyle(
                    fontFamily: AppConstants.appFont,
                    fontSize: appDimension.h6,
                    fontWeight: Dimensions.fontRegular,
                    color: AppColors.black.withValues(alpha: 0.7),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              appText(
                  textName: "I am a:",
                  maxLines: 2,
                  textStyle: TextStyle(
                    fontFamily: AppConstants.appFont,
                    fontSize: appDimension.h3,
                    fontWeight: Dimensions.fontBold,
                    color: AppColors.red,
                  )),

              const SizedBox(height: 12),

              /// Gender
              Obx(() => Column(
                    children: [
                      // Woman option
                      GestureDetector(
                        onTap: () {
                          genderGetxController.change('Woman');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical:
                                MediaQuery.of(context).size.height * 0.0175,
                          ),
                          decoration: BoxDecoration(
                            color: genderGetxController.gender.value == 'Woman'
                                ? AppColors.red
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  genderGetxController.gender.value == 'Woman'
                                      ? AppColors.red
                                      : AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                textName: 'Woman',
                                textStyle: TextStyle(
                                  fontSize: appDimension.h5,
                                  fontWeight: Dimensions.fontRegular,
                                  color: genderGetxController.gender.value ==
                                          'Woman'
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                              ),
                              Icon(
                                Icons.check,
                                color:
                                    genderGetxController.gender.value == 'Woman'
                                        ? AppColors.white
                                        : AppColors.inactive,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Man option
                      GestureDetector(
                        onTap: () {
                          genderGetxController.change('Man');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical:
                                MediaQuery.of(context).size.height * 0.0175,
                          ),
                          decoration: BoxDecoration(
                            color: genderGetxController.gender.value == 'Man'
                                ? AppColors.red
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: genderGetxController.gender.value == 'Man'
                                  ? AppColors.red
                                  : AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appText(
                                textName: 'Man',
                                textStyle: TextStyle(
                                  fontSize: appDimension.h5,
                                  fontWeight: Dimensions.fontRegular,
                                  color:
                                      genderGetxController.gender.value == 'Man'
                                          ? AppColors.white
                                          : AppColors.black,
                                ),
                              ),
                              Icon(
                                Icons.check,
                                color:
                                    genderGetxController.gender.value == 'Man'
                                        ? AppColors.white
                                        : AppColors.inactive,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              /// Location
              appText(
                  textName: "Location:",
                  maxLines: 2,
                  textStyle: TextStyle(
                    fontFamily: AppConstants.appFont,
                    fontSize: appDimension.h3,
                    fontWeight: Dimensions.fontBold,
                    color: AppColors.red,
                  )),
              const SizedBox(height: 12),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: selected ? AppColors.red : AppColors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: selected ? AppColors.red : AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: selected ? AppColors.red : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: selected ? AppColors.red : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Add more decoration..
                ),
                value: selectedLocation,
                hint: appText(
                  textName: "Select Location",
                  textStyle: TextStyle(
                    fontSize: appDimension.h5,
                    fontWeight: Dimensions.fontRegular,
                    color: selected ? AppColors.white : AppColors.black,
                  ),
                ),
                items: locations.map((religion) {
                  return DropdownMenuItem<String>(
                    value: religion,
                    child: appText(
                      textName: religion,
                      textStyle: TextStyle(
                        fontSize: appDimension.h5,
                        fontWeight: Dimensions.fontRegular,
                        color: selected ? AppColors.white : AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                    selected = true;
                  });
                },
                onSaved: (value) {
                  selectedLocation = value.toString();
                },
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.only(right: 10),
                ),
                iconStyleData: IconStyleData(
                  openMenuIcon: Transform.rotate(
                    angle: 3.1415926535897932,
                    child: ImageIcon(
                      AssetImage(AppIcons.arrowDown),
                      size: 20,
                      color: selected ? AppColors.white : AppColors.inactive,
                    ),
                  ),
                  icon: ImageIcon(
                    AssetImage(AppIcons.arrowDown),
                    size: 20,
                    color: selected ? AppColors.white : AppColors.inactive,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  isOverButton: false,
                  elevation: 0,
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: selected ? AppColors.red : AppColors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              /// Interests grid
              appText(
                  textName: "Interests:",
                  maxLines: 2,
                  textStyle: TextStyle(
                    fontFamily: AppConstants.appFont,
                    fontSize: appDimension.h3,
                    fontWeight: Dimensions.fontBold,
                    color: AppColors.red,
                  )),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: interests.map((interest) {
                  final isSelected =
                      selectedInterests.contains(interest['label']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedInterests.remove(interest['label']);
                        } else {
                          selectedInterests.add(interest['label']);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.red : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.red : AppColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            interest['icon'],
                            size: 20,
                            color: isSelected ? AppColors.white : AppColors.red,
                          ),
                          const SizedBox(width: 8),
                          appText(
                              textName: interest['label'],
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h6,
                                fontWeight: Dimensions.fontRegular,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.black,
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              /// Continue Button
              appButton(
                  height: MediaQuery.of(context).size.height * 0.07,
                  fontSize: appDimension.h5,
                  text: "Continue",
                  onTap: () async {
                    if (selectedLocation == null || selectedInterests.isEmpty) {
                      final snackbar = SnackBar(
                        backgroundColor: AppColors.secondary,
                        // padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        content: appText(
                            textName: selectedInterests.isEmpty
                                ? "Select Interests"
                                : "Select Location",
                            textStyle: TextStyle(
                              fontFamily: AppConstants.appFont,
                              fontSize: appDimension.h5,
                              fontWeight: Dimensions.fontBold,
                              color: AppColors.white,
                            )),
                        elevation: 0,

                        behavior: SnackBarBehavior.floating,
                      );
                      showSnackbar(context, snackbar);
                    } else {
                      try {
                        String jwt = await AuthService().signUp(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                            age.toString(),
                            selectedLocation!,
                            genderGetxController.gender.value,
                            selectedInterests.toList());
                        final info = JWT.decode(jwt);
                        debugPrint(info.payload.toString());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        print(e.toString());
                        final snackbar = SnackBar(
                          backgroundColor: AppColors.secondary,
                          // padding: const EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: appText(
                              textName: e.toString().substring(11),
                              textStyle: TextStyle(
                                fontFamily: AppConstants.appFont,
                                fontSize: appDimension.h5,
                                fontWeight: Dimensions.fontBold,
                                color: AppColors.white,
                              )),
                          elevation: 0,

                          behavior: SnackBarBehavior.floating,
                        );
                        showSnackbar(context, snackbar);
                        _pageController.animateToPage(0, duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      }
                    }
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    ];
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.bg,
          body: PageView.builder(
              itemCount: pages.length,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return pages[index];
              })),
    );
  }
}

class GenderGetxController extends GetxController {
  var gender = "Man".obs;
  change(String value) {
    gender.value = value;
  }
}
