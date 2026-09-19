import 'package:equatable/equatable.dart';

class RefundsResponse extends Equatable {
  final bool? success;
  final String? message;
  final RefundsData? data;
  final dynamic errors;

  const RefundsResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory RefundsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundsResponse();
    return RefundsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RefundsData.fromJson(json['data'] as Map<String, dynamic>?)
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

class RefundsData extends Equatable {
  final List<RefundItem> results;
  final List<RefundItem> items;
  final RefundPaginationData? pagination;
  final RefundMetrics? metrics;

  const RefundsData({
    this.results = const [],
    List<RefundItem>? items,
    this.pagination,
    this.metrics,
  }) : items = items ?? results;

  factory RefundsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundsData();

    List<RefundItem> refundList = [];
    final rawList = json['items'] ?? json['results'];
    if (rawList != null && rawList is List) {
      refundList = rawList
          .map((item) => RefundItem.fromJson(item as Map<String, dynamic>?))
          .toList();
    }

    return RefundsData(
      results: refundList,
      items: refundList,
      pagination: json['pagination'] != null
          ? RefundPaginationData.fromJson(
              json['pagination'] as Map<String, dynamic>?,
            )
          : null,
      metrics: json['metrics'] != null
          ? RefundMetrics.fromJson(json['metrics'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
      'metrics': metrics?.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, items, pagination, metrics];
}

class RefundItem extends Equatable {
  final String id;
  final String refundNo;
  final num amount;
  final String formattedAmount;
  final String refundType;
  final num refundValue;
  final String reason;
  final String status;
  final String statusLabel;
  final String createdAt;
  final String settledAt;
  final RefundCustomer? customer;
  final RefundOrder? order;
  final RefundPaymentMode? paymentMode;

  const RefundItem({
    this.id = '',
    this.refundNo = '',
    this.amount = 0,
    this.formattedAmount = '',
    this.refundType = '',
    this.refundValue = 0,
    this.reason = '',
    this.status = '',
    this.statusLabel = '',
    this.createdAt = '',
    this.settledAt = '',
    this.customer,
    this.order,
    this.paymentMode,
  });

  factory RefundItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundItem();
    return RefundItem(
      id: json['id']?.toString() ?? '',
      refundNo: json['refund_no']?.toString() ?? '',
      amount: num.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      formattedAmount: json['formatted_amount']?.toString() ?? '',
      refundType: json['refund_type']?.toString() ?? '',
      refundValue: num.tryParse(json['refund_value']?.toString() ?? '0') ?? 0,
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      settledAt: json['settled_at']?.toString() ?? '',
      customer: json['customer'] != null
          ? RefundCustomer.fromJson(json['customer'] as Map<String, dynamic>?)
          : null,
      order: json['order'] != null
          ? RefundOrder.fromJson(json['order'] as Map<String, dynamic>?)
          : null,
      paymentMode: json['payment_mode'] != null
          ? RefundPaymentMode.fromJson(
              json['payment_mode'] as Map<String, dynamic>?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'refund_no': refundNo,
      'amount': amount,
      'formatted_amount': formattedAmount,
      'refund_type': refundType,
      'refund_value': refundValue,
      'reason': reason,
      'status': status,
      'status_label': statusLabel,
      'created_at': createdAt,
      'settled_at': settledAt,
      'customer': customer?.toJson(),
      'order': order?.toJson(),
      'payment_mode': paymentMode?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        refundNo,
        amount,
        formattedAmount,
        refundType,
        refundValue,
        reason,
        status,
        statusLabel,
        createdAt,
        settledAt,
        customer,
        order,
        paymentMode,
      ];
}

class RefundCustomer extends Equatable {
  final String id;
  final String fullName;
  final String initials;
  final String mobileNo;
  final String email;
  final String cityName;
  final RefundCustomerCity? city;

  const RefundCustomer({
    this.id = '',
    this.fullName = '',
    this.initials = '',
    this.mobileNo = '',
    this.email = '',
    this.cityName = '',
    this.city,
  });

  factory RefundCustomer.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundCustomer();
    return RefundCustomer(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      initials: json['initials']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      city: json['city'] != null
          ? RefundCustomerCity.fromJson(json['city'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'initials': initials,
      'mobile_no': mobileNo,
      'email': email,
      'city_name': cityName,
      'city': city?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        initials,
        mobileNo,
        email,
        cityName,
        city,
      ];
}

class RefundCustomerCity extends Equatable {
  final String id;
  final String title;

  const RefundCustomerCity({
    this.id = '',
    this.title = '',
  });

  factory RefundCustomerCity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundCustomerCity();
    return RefundCustomerCity(
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

class RefundOrder extends Equatable {
  final String id;
  final String invoiceId;
  final String bookingId;
  final String orderType;
  final String itemTitle;
  final num totalAmount;
  final num paidAmount;
  final String formattedTotalAmount;

  const RefundOrder({
    this.id = '',
    this.invoiceId = '',
    this.bookingId = '',
    this.orderType = '',
    this.itemTitle = '',
    this.totalAmount = 0,
    this.paidAmount = 0,
    this.formattedTotalAmount = '',
  });

  factory RefundOrder.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundOrder();
    return RefundOrder(
      id: json['id']?.toString() ?? '',
      invoiceId: json['invoice_id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      orderType: json['order_type']?.toString() ?? '',
      itemTitle: json['item_title']?.toString() ?? '',
      totalAmount: num.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      paidAmount: num.tryParse(json['paid_amount']?.toString() ?? '0') ?? 0,
      formattedTotalAmount: json['formatted_total_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'booking_id': bookingId,
      'order_type': orderType,
      'item_title': itemTitle,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'formatted_total_amount': formattedTotalAmount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        invoiceId,
        bookingId,
        orderType,
        itemTitle,
        totalAmount,
        paidAmount,
        formattedTotalAmount,
      ];
}

class RefundPaymentMode extends Equatable {
  final String id;
  final String name;

  const RefundPaymentMode({
    this.id = '',
    this.name = '',
  });

  factory RefundPaymentMode.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundPaymentMode();
    return RefundPaymentMode(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class RefundPaginationData extends Equatable {
  final int count;
  final int totalPages;
  final int currentPage;
  final int limit;

  const RefundPaginationData({
    this.count = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.limit = 10,
  });

  factory RefundPaginationData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundPaginationData();
    return RefundPaginationData(
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

class RefundMetrics extends Equatable {
  final int totalCount;
  final int requestedCount;
  final int processingCount;
  final int approvedCount;
  final int rejectedCount;
  final int settledCount;
  final num totalRequestedAmount;
  final String formattedTotalRequestedAmount;
  final num totalSettledAmount;
  final String formattedTotalSettledAmount;

  const RefundMetrics({
    this.totalCount = 0,
    this.requestedCount = 0,
    this.processingCount = 0,
    this.approvedCount = 0,
    this.rejectedCount = 0,
    this.settledCount = 0,
    this.totalRequestedAmount = 0,
    this.formattedTotalRequestedAmount = '₹0',
    this.totalSettledAmount = 0,
    this.formattedTotalSettledAmount = '₹0',
  });

  factory RefundMetrics.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RefundMetrics();
    return RefundMetrics(
      totalCount: json['total_count'] as int? ?? 0,
      requestedCount: json['requested_count'] as int? ?? 0,
      processingCount: json['processing_count'] as int? ?? 0,
      approvedCount: json['approved_count'] as int? ?? 0,
      rejectedCount: json['rejected_count'] as int? ?? 0,
      settledCount: json['settled_count'] as int? ?? 0,
      totalRequestedAmount:
          num.tryParse(json['total_requested_amount']?.toString() ?? '0') ?? 0,
      formattedTotalRequestedAmount:
          json['formatted_total_requested_amount']?.toString() ?? '₹0',
      totalSettledAmount:
          num.tryParse(json['total_settled_amount']?.toString() ?? '0') ?? 0,
      formattedTotalSettledAmount:
          json['formatted_total_settled_amount']?.toString() ?? '₹0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'requested_count': requestedCount,
      'processing_count': processingCount,
      'approved_count': approvedCount,
      'rejected_count': rejectedCount,
      'settled_count': settledCount,
      'total_requested_amount': totalRequestedAmount,
      'formatted_total_requested_amount': formattedTotalRequestedAmount,
      'total_settled_amount': totalSettledAmount,
      'formatted_total_settled_amount': formattedTotalSettledAmount,
    };
  }

  @override
  List<Object?> get props => [
        totalCount,
        requestedCount,
        processingCount,
        approvedCount,
        rejectedCount,
        settledCount,
        totalRequestedAmount,
        formattedTotalRequestedAmount,
        totalSettledAmount,
        formattedTotalSettledAmount,
      ];
}
