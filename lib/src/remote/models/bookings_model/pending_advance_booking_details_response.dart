import 'package:equatable/equatable.dart';
import 'pending_advance_bookings_response.dart';

class PendingAdvanceBookingDetailsResponse extends Equatable {
  final bool? success;
  final String? message;
  final PendingAdvanceBookingDetailsData? data;
  final dynamic errors;

  const PendingAdvanceBookingDetailsResponse({
    this.success = false,
    this.message = '',
    this.data,
    this.errors,
  });

  factory PendingAdvanceBookingDetailsResponse.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return const PendingAdvanceBookingDetailsResponse();
    return PendingAdvanceBookingDetailsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? PendingAdvanceBookingDetailsData.fromJson(
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

class PendingAdvanceBookingDetailsData extends Equatable {
  final String id;
  final String bookingId;
  final PendingAdvanceCustomer? customer;
  final String itemTitle;
  final num totalAmount;
  final String formattedTotalAmount;
  final num pendingAdvanceAmount;
  final String formattedPendingAdvanceAmount;
  final String createdAt;
  final List<AdvanceEntryItem> advanceEntries;

  const PendingAdvanceBookingDetailsData({
    this.id = '',
    this.bookingId = '',
    this.customer,
    this.itemTitle = '',
    this.totalAmount = 0,
    this.formattedTotalAmount = '',
    this.pendingAdvanceAmount = 0,
    this.formattedPendingAdvanceAmount = '',
    this.createdAt = '',
    this.advanceEntries = const [],
  });

  factory PendingAdvanceBookingDetailsData.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return const PendingAdvanceBookingDetailsData();

    List<AdvanceEntryItem> entries = [];
    final rawEntries = json['advance_entries'];
    if (rawEntries != null && rawEntries is List) {
      entries = rawEntries
          .map((item) =>
              AdvanceEntryItem.fromJson(item as Map<String, dynamic>?))
          .toList();
    }

    return PendingAdvanceBookingDetailsData(
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
      advanceEntries: entries,
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
      'advance_entries': advanceEntries.map((e) => e.toJson()).toList(),
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
        advanceEntries,
      ];
}

class AdvanceEntryItem extends Equatable {
  final String id;
  final num amount;
  final String paymentModeName;
  final bool isApproved;
  final String createdAt;

  const AdvanceEntryItem({
    this.id = '',
    this.amount = 0,
    this.paymentModeName = '',
    this.isApproved = false,
    this.createdAt = '',
  });

  factory AdvanceEntryItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AdvanceEntryItem();
    return AdvanceEntryItem(
      id: json['id']?.toString() ?? '',
      amount: num.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      paymentModeName: json['payment_mode_name']?.toString() ?? '',
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'payment_mode_name': paymentModeName,
      'is_approved': isApproved,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        paymentModeName,
        isApproved,
        createdAt,
      ];
}
