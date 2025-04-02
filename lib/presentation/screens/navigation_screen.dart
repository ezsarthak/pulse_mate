import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/presentation/screens/chat_screen.dart';
import 'package:pulse_mate/presentation/screens/home_screen.dart';
import 'package:pulse_mate/presentation/screens/like_screen.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  final List<Widget> pages = [HomeScreen(), ChatScreen()];
  final NavigationController navigationController =
      Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (int newIndex) {
          navigationController.change(newIndex);
        },
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Obx(() => pages[navigationController.ind.value]);
        },
      ),
      bottomNavigationBar: Obx(
        () => CustomNavigationBar(
          scaleFactor: 0.3,
          strokeColor: AppColors.red,
          iconSize: 28,
          elevation: 0,
          backgroundColor: AppColors.bg,
          selectedColor: AppColors.red,
          unSelectedColor: AppColors.inactive,
          isFloating: false,
          currentIndex: navigationController.ind.value,
          scaleCurve: Curves.bounceOut,
          bubbleCurve: Curves.easeInOut,
          onTap: (int newIndex) {
            navigationController.change(newIndex);
            pageController.animateToPage(newIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home),
            ),
            CustomNavigationBarItem(icon: const Icon(Icons.message)),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  var ind = 0.obs;
  change(int newIndex) {
    ind.value = newIndex;
  }
}
