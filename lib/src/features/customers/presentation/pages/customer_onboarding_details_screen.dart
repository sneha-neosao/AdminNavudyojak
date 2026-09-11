import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/customer_details_bloc/customer_details_bloc.dart';
import '../../widget/customer_detail_item.dart';
import '../../widget/customer_onboarding_details_content_widget.dart';

class CustomerOnboardingDetailsScreen extends StatefulWidget {
  final CustomerDetailItem? customer;
  final String? customerId;

  const CustomerOnboardingDetailsScreen({
    super.key,
    this.customer,
    this.customerId,
  });

  @override
  State<CustomerOnboardingDetailsScreen> createState() =>
      _CustomerOnboardingDetailsScreenState();
}

class _CustomerOnboardingDetailsScreenState
    extends State<CustomerOnboardingDetailsScreen> {
  late final CustomerDetailsBloc _customerDetailsBloc;

  @override
  void initState() {
    super.initState();
    _customerDetailsBloc = getIt<CustomerDetailsBloc>();
    final id = widget.customerId ?? widget.customer?.id;
    if (id != null && id.isNotEmpty) {
      _customerDetailsBloc.add(GetCustomerDetailsEvent(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerDetailsBloc>.value(
          value: _customerDetailsBloc,
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: CustomerOnboardingDetailsContentWidget(
            customer: widget.customer,
            customerId: widget.customerId ?? widget.customer?.id,
          ),
        ),
      ),
    );
  }
}
