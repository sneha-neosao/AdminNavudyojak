import 'package:admin_navudyojak/src/features/request/widgets/request_content_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        bottom: false,
        child: RequestContentWidget(),
      ),
    );
  }
}
