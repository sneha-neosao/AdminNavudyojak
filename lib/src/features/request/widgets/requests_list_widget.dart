import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/request_model/refunds_response.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/refunds_bloc/refunds_bloc.dart';
import 'machine_return_settlements_card_widget.dart';

class RequestsListWidget extends StatefulWidget {
  const RequestsListWidget({super.key});

  @override
  State<RequestsListWidget> createState() => _RequestsListWidgetState();
}

class _RequestsListWidgetState extends State<RequestsListWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 150) {
        context.read<RefundsBloc>().add(LoadMoreRefundsEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<RefundsBloc, RefundsState>(
      listener: (context, state) {
        if (state is RefundsFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RefundsLoadingState;
        final isLoadingMore =
            state is RefundsSuccessState && state.isLoadingMore;
        final errorMessage =
            state is RefundsFailureState ? state.message : null;

        List<RefundItem> refundItems = [];
        if (state is RefundsSuccessState) {
          refundItems = state.allResults;
        }

        return RefreshIndicator(
          color: AppColor.primary,
          backgroundColor: AppColor.pureWhite,
          onRefresh: () async {
            context.read<RefundsBloc>().add(RefreshRefundsEvent());
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.hS,
                MachineReturnSettlementsCardWidget(
                  items: refundItems,
                  isLoading: isLoading,
                  isLoadingMore: isLoadingMore,
                  errorMessage: errorMessage,
                  onRetry: () {
                    context.read<RefundsBloc>().add(
                          const GetRefundsEvent(page: 1, limit: 10),
                        );
                  },
                ),
                24.hS,
              ],
            ),
          ),
        );
      },
    );
  }
}
