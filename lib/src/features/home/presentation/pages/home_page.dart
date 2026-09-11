import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../widget/home_content_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: HomeContentWidget(),
      ),
    );
  }
}
