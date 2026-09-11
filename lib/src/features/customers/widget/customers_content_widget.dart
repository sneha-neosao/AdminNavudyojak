import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_route_path.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/customers_bloc/customers_bloc.dart';
import 'customer_detail_item.dart';
import 'customer_header_widget.dart';
import 'customer_list_card_widget.dart';
import 'customer_search_bar_widget.dart';

class CustomersContentWidget extends StatefulWidget {
  const CustomersContentWidget({super.key});

  @override
  State<CustomersContentWidget> createState() => _CustomersContentWidgetState();
}

class _CustomersContentWidgetState extends State<CustomersContentWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _lastDispatchedSearch = '';

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
        context.read<CustomersBloc>().add(LoadMoreCustomersEvent());
      }
    }
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = val.trim();
      if (query.length >= 3) {
        if (_lastDispatchedSearch != query) {
          _lastDispatchedSearch = query;
          context.read<CustomersBloc>().add(
                GetCustomersEvent(page: 1, limit: 10, search: query),
              );
        }
      } else if (query.isEmpty && _lastDispatchedSearch.isNotEmpty) {
        _lastDispatchedSearch = '';
        context.read<CustomersBloc>().add(
              const GetCustomersEvent(page: 1, limit: 10, search: null),
            );
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersBloc, CustomersState>(
      listener: (context, state) {
        if (state is CustomersFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CustomersLoadingState;
        final isLoadingMore =
            state is CustomersSuccessState && state.isLoadingMore;
        final errorMessage =
            state is CustomersFailureState ? state.message : null;

        List<CustomerDetailItem> customerItems = [];
        if (state is CustomersSuccessState) {
          customerItems =
              state.allResults.map((c) => c.toCustomerDetailItem()).toList();
        }

        return RefreshIndicator(
          color: AppColor.primary,
          backgroundColor: AppColor.pureWhite,
          onRefresh: () async {
            context.read<CustomersBloc>().add(RefreshCustomersEvent());
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.hS,
                const CustomerHeaderWidget(),
                16.hS,
                CustomerSearchBarWidget(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
                16.hS,
                CustomerListCardWidget(
                  items: customerItems,
                  isLoading: isLoading,
                  isLoadingMore: isLoadingMore,
                  errorMessage: errorMessage,
                  onRetry: () {
                    context.read<CustomersBloc>().add(
                          GetCustomersEvent(
                            page: 1,
                            limit: 10,
                            search: _lastDispatchedSearch.isNotEmpty
                                ? _lastDispatchedSearch
                                : null,
                          ),
                        );
                  },
                  onItemTap: (customer) {
                    context.push(
                      AppRoute.customerOnboardingDetails.path,
                      extra: customer,
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
