import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../bloc/customer_details_bloc/customer_details_bloc.dart';
import 'customer_detail_item.dart';
import 'customer_details_header_widget.dart';
import 'customer_onboarding_card_widget.dart';
// import 'customer_search_bar_widget.dart';

class CustomerOnboardingDetailsContentWidget extends StatelessWidget {
  final CustomerDetailItem? customer;
  final String? customerId;

  const CustomerOnboardingDetailsContentWidget({
    super.key,
    this.customer,
    this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.primary,
      backgroundColor: AppColor.pureWhite,
      onRefresh: () async {
        final id = customerId ?? customer?.id;
        if (id != null && id.isNotEmpty) {
          context.read<CustomerDetailsBloc>().add(RefreshCustomerDetailsEvent(id));
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.hS,
            const CustomerDetailsHeaderWidget(),
            16.hS,
            // Search field commented out per user request
            // const CustomerSearchBarWidget(),
            // 16.hS,
            CustomerOnboardingCardWidget(
              customer: customer,
              customerId: customerId,
            ),
            24.hS,
          ],
        ),
      ),
    );
  }
}
