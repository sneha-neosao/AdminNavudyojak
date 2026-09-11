import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../widget/customers_content_widget.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        bottom: false,
        child: CustomersContentWidget(),
      ),
    );
  }
}
