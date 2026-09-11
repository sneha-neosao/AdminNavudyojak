import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_header_widget.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_list_card_widget.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../routes/app_route_path.dart';

class CustomersContentWidget extends StatefulWidget {
  const CustomersContentWidget({super.key});

  @override
  State<CustomersContentWidget> createState() => _CustomersContentWidgetState();
}

class _CustomersContentWidgetState extends State<CustomersContentWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<CustomerDetailItem> _allCustomers = [
    CustomerDetailItem(
      initials: 'SS',
      name: 'Sunita Sharma',
      phone: '98765 43210',
      city: 'Pune',
      amount: '₹1,82,400',
      code: 'CUST-1248',
    ),
    CustomerDetailItem(
      initials: 'VP',
      name: 'Vijay Pawar',
      phone: '98220 11823',
      city: 'Nashik',
      amount: '₹94,500',
      code: 'CUST-1247',
    ),
    CustomerDetailItem(
      initials: 'NK',
      name: 'Neha Kulkarni',
      phone: '97654 22190',
      city: 'Kolhapur',
      amount: '₹68,200',
      code: 'CUST-1246',
    ),
    CustomerDetailItem(
      initials: 'RJ',
      name: 'Ramesh Jagtap',
      phone: '98901 44872',
      city: 'Satara',
      amount: '₹1,14,000',
      code: 'CUST-1245',
    ),
    CustomerDetailItem(
      initials: 'PG',
      name: 'Pooja Gaikwad',
      phone: '98123 77882',
      city: 'Pune',
      amount: '₹52,800',
      code: 'CUST-1244',
    ),
    CustomerDetailItem(
      initials: 'KM',
      name: 'Kiran More',
      phone: '99872 31456',
      city: 'Sangli',
      amount: '₹81,650',
      code: 'CUST-1243',
    ),
    CustomerDetailItem(
      initials: 'MS',
      name: 'Meena Shinde',
      phone: '98604 55431',
      city: 'Pune',
      amount: '₹1,26,700',
      code: 'CUST-1242',
    ),
    CustomerDetailItem(
      initials: 'AD',
      name: 'Amit Deshmukh',
      phone: '99221 44312',
      city: 'Nashik',
      amount: '₹74,300',
      code: 'CUST-1241',
    ),
    CustomerDetailItem(
      initials: 'SJ',
      name: 'Sonal Jadhav',
      phone: '97855 12348',
      city: 'Pune',
      amount: '₹91,200',
      code: 'CUST-1240',
    ),
    CustomerDetailItem(
      initials: 'RP',
      name: 'Rajesh Patil',
      phone: '98500 11122',
      city: 'Satara',
      amount: '₹1,48,900',
      code: 'CUST-1239',
    ),
  ];

  List<CustomerDetailItem> get _filteredCustomers {
    if (_searchQuery.trim().isEmpty) {
      return _allCustomers;
    }
    final q = _searchQuery.toLowerCase().trim();
    return _allCustomers.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.phone.replaceAll(' ', '').contains(q) ||
          c.city.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const CustomerHeaderWidget(),
          16.hS,
          CustomerSearchBarWidget(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          16.hS,
          CustomerListCardWidget(
            items: _filteredCustomers,
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
    );
  }
}
