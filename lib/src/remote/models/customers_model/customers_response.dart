import 'package:equatable/equatable.dart';
import '../../../features/customers/widget/customer_detail_item.dart';

class CustomersResponse extends Equatable {
  final bool? success;
  final String? message;
  final CustomersData? data;
  final dynamic errors;

  const CustomersResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory CustomersResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomersResponse();
    return CustomersResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CustomersData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors];
}

class CustomersData extends Equatable {
  final List<CustomerItem> results;
  final PaginationData? pagination;

  const CustomersData({
    this.results = const [],
    this.pagination,
  });

  factory CustomersData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomersData();

    List<CustomerItem> customerList = [];
    if (json['results'] != null && json['results'] is List) {
      customerList = (json['results'] as List)
          .map((item) => CustomerItem.fromJson(item as Map<String, dynamic>?))
          .toList();
    }

    return CustomersData(
      results: customerList,
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(json['pagination'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, pagination];
}

class CustomerItem extends Equatable {
  final String id;
  final String customerCode;
  final String salutation;
  final String fullName;
  final String initials;
  final String email;
  final String mobileNo;
  final CustomerLocation? city;
  final CustomerLocation? state;
  final String cityName;
  final String stateName;
  final num totalAmount;
  final String formattedAmount;
  final int ordersCount;
  final bool isActive;
  final String createdAt;

  const CustomerItem({
    this.id = '',
    this.customerCode = '',
    this.salutation = '',
    this.fullName = '',
    this.initials = '',
    this.email = '',
    this.mobileNo = '',
    this.city,
    this.state,
    this.cityName = '',
    this.stateName = '',
    this.totalAmount = 0,
    this.formattedAmount = '',
    this.ordersCount = 0,
    this.isActive = true,
    this.createdAt = '',
  });

  factory CustomerItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerItem();
    return CustomerItem(
      id: json['id']?.toString() ?? '',
      customerCode: json['customer_code']?.toString() ?? '',
      salutation: json['salutation']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      initials: json['initials']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      city: json['city'] != null
          ? CustomerLocation.fromJson(json['city'] as Map<String, dynamic>?)
          : null,
      state: json['state'] != null
          ? CustomerLocation.fromJson(json['state'] as Map<String, dynamic>?)
          : null,
      cityName: json['city_name']?.toString() ??
          (json['city'] != null ? json['city']['title']?.toString() ?? '' : ''),
      stateName: json['state_name']?.toString() ??
          (json['state'] != null ? json['state']['title']?.toString() ?? '' : ''),
      totalAmount: json['total_amount'] as num? ?? 0,
      formattedAmount: json['formatted_amount']?.toString() ??
          (json['total_amount'] != null ? '₹${json['total_amount']}' : '₹0'),
      ordersCount: json['orders_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_code': customerCode,
      'salutation': salutation,
      'full_name': fullName,
      'initials': initials,
      'email': email,
      'mobile_no': mobileNo,
      'city': city?.toJson(),
      'state': state?.toJson(),
      'city_name': cityName,
      'state_name': stateName,
      'total_amount': totalAmount,
      'formatted_amount': formattedAmount,
      'orders_count': ordersCount,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }

  /// Converts this API model into CustomerDetailItem for backward compatibility with UI widgets
  CustomerDetailItem toCustomerDetailItem() {
    return CustomerDetailItem(
      initials: initials.isNotEmpty
          ? initials
          : (fullName.isNotEmpty ? fullName[0].toUpperCase() : 'C'),
      name: fullName.isNotEmpty ? fullName : 'Customer',
      phone: mobileNo,
      city: cityName.isNotEmpty ? cityName : (city?.title ?? ''),
      amount: formattedAmount.isNotEmpty ? formattedAmount : '₹$totalAmount',
      code: customerCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerCode,
        salutation,
        fullName,
        initials,
        email,
        mobileNo,
        city,
        state,
        cityName,
        stateName,
        totalAmount,
        formattedAmount,
        ordersCount,
        isActive,
        createdAt,
      ];
}

class CustomerLocation extends Equatable {
  final String id;
  final String title;

  const CustomerLocation({
    this.id = '',
    this.title = '',
  });

  factory CustomerLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerLocation();
    return CustomerLocation(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  List<Object?> get props => [id, title];
}

class PaginationData extends Equatable {
  final int count;
  final int totalPages;
  final int currentPage;
  final int limit;

  const PaginationData({
    this.count = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.limit = 10,
  });

  factory PaginationData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PaginationData();
    return PaginationData(
      count: json['count'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 1,
      currentPage: json['current_page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total_pages': totalPages,
      'current_page': currentPage,
      'limit': limit,
    };
  }

  @override
  List<Object?> get props => [count, totalPages, currentPage, limit];
}
