// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:pulse_mate/presentation/view_model/welcome_viewmodel.dart';
//
// /// Slider
// CarouselSlider buildHomeCarousel({
//   required int index,
//   required List<String> imgList,
//   required CarouselGetxController carouselSliderIndex,
//   required height,
// }) {
//   return CarouselSlider.builder(
//     carouselController: inx,
//     itemCount: imgList.length,
//     itemBuilder: (context, index, pageViewIndex) {
//       return Container(
//         width: double.maxFinite,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             image: DecorationImage(image: AssetImage(imgList[index]))),
//       );
//     },
//     options: CarouselOptions(
//         autoPlay: true,
//         autoPlayCurve: Curves.easeInOut,
//         autoPlayAnimationDuration: const Duration(milliseconds: 500),
//         viewportFraction: 0.6,
//         enlargeCenterPage: true,
//         initialPage: 0,
//         enableInfiniteScroll: true,
//         pageSnapping: true,
//         height: height,
//         scrollPhysics: const BouncingScrollPhysics(),
//         onPageChanged: (index, pageChangeReason) {
//           carouselSliderIndex.change(index);
//         }),
//   );
// }