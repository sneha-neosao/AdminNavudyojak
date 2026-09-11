import 'package:flutter/material.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import 'machine_return_settlements_card_widget.dart';
import 'requests_header_widget.dart';

class RequestContentWidget extends StatelessWidget {
  const RequestContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const RequestsHeaderWidget(),
          16.hS,
          const MachineReturnSettlementsCardWidget(),
          24.hS,
        ],
      ),
    );
  }
}
