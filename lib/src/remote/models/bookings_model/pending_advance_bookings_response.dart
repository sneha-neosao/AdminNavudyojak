import 'package:equatable/equatable.dart';

class PendingAdvanceBookingsResponse extends Equatable {
  final bool? success;
  final String? message;
  final PendingAdvanceBookingsData? data;
  final dynamic errors;

  const PendingAdvanceBookingsResponse({
    this.success = false,
    this.message = '',
    this.data,
    this.errors,
  });

  factory PendingAdvanceBookingsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PendingAdvanceBookingsResponse();
    return PendingAdvanceBookingsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? PendingAdvanceBookingsData.fromJson(
              json['data'] as Map<String, dynamic>?,
            )
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

class PendingAdvanceBookingsData extends Equatable {
  final List<PendingAdvanceBookingItem> results;
  final List<PendingAdvanceBookingItem> items;
  final PendingAdvancePagination? pagination;

  const PendingAdvanceBookingsData({
    this.results = const [],
    List<PendingAdvanceBookingItem>? items,
    this.pagination,
  }) : items = items ?? results;

  factory PendingAdvanceBookingsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PendingAdvanceBookingsData();

    List<PendingAdvanceBookingItem> bookingList = [];
    final rawList = json['results'] ?? json['items'];
    if (rawList != null && rawList is List) {
      bookingList = rawList
          .map((item) =>
              PendingAdvanceBookingItem.fromJson(item as Map<String, dynamic>?))
          .toList();
    }

    return PendingAdvanceBookingsData(
      results: bookingList,
      items: bookingList,
      pagination: json['pagination'] != null
          ? PendingAdvancePagination.fromJson(
              json['pagination'] as Map<String, dynamic>?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'items': items.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, items, pagination];
}

class PendingAdvanceBookingItem extends Equatable {
  final String id;
  final String bookingId;
  final PendingAdvanceCustomer? customer;
  final String itemTitle;
  final num totalAmount;
  final String formattedTotalAmount;
  final num pendingAdvanceAmount;
  final String formattedPendingAdvanceAmount;
  final String createdAt;

  const PendingAdvanceBookingItem({
    this.id = '',
    this.bookingId = '',
    this.customer,
    this.itemTitle = '',
    this.totalAmount = 0,
    this.formattedTotalAmount = '',
    this.pendingAdvanceAmount = 0,
    this.formattedPendingAdvanceAmount = '',
    this.createdAt = '',
  });

  factory PendingAdvanceBookingItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PendingAdvanceBookingItem();
    return PendingAdvanceBookingItem(
      id: json['id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      customer: json['customer'] != null
          ? PendingAdvanceCustomer.fromJson(
              json['customer'] as Map<String, dynamic>?,
            )
          : null,
      itemTitle: json['item_title']?.toString() ?? '',
      totalAmount: num.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      formattedTotalAmount: json['formatted_total_amount']?.toString() ?? '',
      pendingAdvanceAmount:
          num.tryParse(json['pending_advance_amount']?.toString() ?? '0') ?? 0,
      formattedPendingAdvanceAmount:
          json['formatted_pending_advance_amount']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'customer': customer?.toJson(),
      'item_title': itemTitle,
      'total_amount': totalAmount,
      'formatted_total_amount': formattedTotalAmount,
      'pending_advance_amount': pendingAdvanceAmount,
      'formatted_pending_advance_amount': formattedPendingAdvanceAmount,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        bookingId,
        customer,
        itemTitle,
        totalAmount,
        formattedTotalAmount,
        pendingAdvanceAmount,
        formattedPendingAdvanceAmount,
        createdAt,
      ];
}

class PendingAdvanceCustomer extends Equatable {
  final String id;
  final String fullName;
  final String mobileNo;

  const PendingAdvanceCustomer({
    this.id = '',
    this.fullName = '',
    this.mobileNo = '',
  });

  factory PendingAdvanceCustomer.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PendingAdvanceCustomer();
    return PendingAdvanceCustomer(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'mobile_no': mobileNo,
    };
  }

  @override
  List<Object?> get props => [id, fullName, mobileNo];
}

class PendingAdvancePagination extends Equatable {
  final int count;
  final int totalPages;
  final int currentPage;
  final int limit;

  const PendingAdvancePagination({
    this.count = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.limit = 10,
  });

  factory PendingAdvancePagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PendingAdvancePagination();
    return PendingAdvancePagination(
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
