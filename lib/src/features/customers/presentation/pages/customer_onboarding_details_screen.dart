import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_onboarding_details_content_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class CustomerOnboardingDetailsScreen extends StatefulWidget {
  final CustomerDetailItem? customer;

  const CustomerOnboardingDetailsScreen({
    super.key,
    this.customer,
  });

  @override
  State<CustomerOnboardingDetailsScreen> createState() =>
      _CustomerOnboardingDetailsScreenState();
}

class _CustomerOnboardingDetailsScreenState
    extends State<CustomerOnboardingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        bottom: false,
        child: CustomerOnboardingDetailsContentWidget(
          customer: widget.customer,
        ),
      ),
    );
  }
}
