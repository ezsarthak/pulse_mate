import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> token;
  @override
  void initState() {
    token = HomeScreenService.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: FutureBuilder<String>(future:  token.whenComplete(
                () => Future.delayed(const Duration(milliseconds:300))), builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text(snapshot.data!),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },),
      ),
    );
  }
}
