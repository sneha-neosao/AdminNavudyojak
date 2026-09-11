import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_details_header_widget.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_onboarding_card_widget.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_search_bar_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';

class CustomerOnboardingDetailsContentWidget extends StatelessWidget {
  final CustomerDetailItem? customer;

  const CustomerOnboardingDetailsContentWidget({
    super.key,
    this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const CustomerDetailsHeaderWidget(),
          16.hS,
          const CustomerSearchBarWidget(),
          16.hS,
          CustomerOnboardingCardWidget(customer: customer),
          24.hS,
        ],
      ),
    );
  }
}
