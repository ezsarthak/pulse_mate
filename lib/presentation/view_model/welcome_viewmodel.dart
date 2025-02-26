import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselGetxController extends GetxController {
  var ind = 0.obs;
  change(int newIndex) {
    ind.value = newIndex;
  }
}

/// Slider
CarouselSlider buildCarousel({
  required CarouselSliderController carouselSliderController,
  required List<String> imgList,
  required CarouselGetxController carouselSliderIndex,
  required height,
}) {
  return CarouselSlider.builder(
    carouselController: carouselSliderController,
    itemCount: imgList.length,
    itemBuilder: (context, index, pageViewIndex) {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: AssetImage(imgList[index]))),
      );
    },
    options: CarouselOptions(
        autoPlay: true,
        autoPlayCurve: Curves.easeInOut,
        autoPlayAnimationDuration: const Duration(milliseconds: 500),
        viewportFraction: 0.6,
        enlargeCenterPage: true,
        initialPage: 0,
        enableInfiniteScroll: true,
        pageSnapping: true,
        height: height,
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (index, pageChangeReason) {
          carouselSliderIndex.change(index);
        }),
  );
}

/// Dots Indicator
AnimatedSmoothIndicator buildDotsIndicator(
    {required CarouselGetxController carouselSliderIndex}) {
  return AnimatedSmoothIndicator(
    activeIndex: carouselSliderIndex.ind.value,
    count: 3,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 300),
    effect: WormEffect(
      dotHeight: 12,
      dotWidth: 12,
      spacing: 16,
      dotColor: AppColors.black.withValues(alpha: 0.1),
      activeDotColor: AppColors.red,
      type: WormType.normal,
    ),
  );
}
