import 'dart:ui';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pulse_mate/core/services/storage/hive_service.dart';
import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/presentation/screens/match_detail_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<HiveUser> matches = HiveService().getAllHiveUsers();
    final Dimensions appDimension = Dimensions(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          title: FittedBox(
              fit: BoxFit.scaleDown,
              child: appText(
                  textName: "Matches",
                  textStyle: TextStyle(
                    fontFamily: AppConstants.appFont,
                    fontSize: appDimension.h1,
                    fontWeight: Dimensions.fontBold,
                    color: AppColors.black,
                  ))),
          actions: [
            Container(
                height: 52,
                width: 52,
                margin: EdgeInsets.only(right: 12, top: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.favorite,
                  size: 24,
                  color: AppColors.red,
                )),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Center(
            child: matches.isEmpty
                ? Text("No Matches")
                : StaggeredGridView.countBuilder(
                    // scrollDirection: Axis.vertical,
                    // controller: widget.controller,
                    // physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 24),
                    itemCount: matches.length,
                    shrinkWrap: false,
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.07,
                    mainAxisSpacing: 12,
                    addRepaintBoundaries: true,
                    staggeredTileBuilder: (index) =>
                        const StaggeredTile.count(2, 3),
                    crossAxisCount: 4,
                    itemBuilder: (context, index) {
                      return Entry.all(
                        delay: const Duration(milliseconds: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchDetailScreen(
                                        currentMatch:
                                            matches.elementAt(index))));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    matches.elementAt(index).imgUrl!),
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  height: (MediaQuery.of(context).size.width) *
                                      0.12,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    color: Colors.grey.shade200
                                        .withValues(alpha: 0.5),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: appText(
                                            textName: matches[index].name,
                                            textAlign: TextAlign.center,
                                            textStyle: TextStyle(
                                              fontFamily: AppConstants.appFont,
                                              fontSize: appDimension.h5,
                                              fontWeight: Dimensions.fontBold,
                                              color: AppColors.black,
                                            )),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: appText(
                                            textName: matches[index].age,
                                            textAlign: TextAlign.center,
                                            textStyle: TextStyle(
                                              fontFamily: AppConstants.appFont,
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
                          ),
                        ),
                      );
                    }),
          ),
        ),
      ),
    );
  }
}
