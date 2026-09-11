import 'package:equatable/equatable.dart';
import '../../../features/customers/widget/customer_detail_item.dart';
import '../../../features/customers/widget/customer_timeline_event.dart';

class CustomerDetailsResponse extends Equatable {
  final bool? success;
  final String? message;
  final CustomerDetailsData? data;
  final dynamic errors;

  const CustomerDetailsResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerDetailsResponse();
    return CustomerDetailsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CustomerDetailsData.fromJson(json['data'] as Map<String, dynamic>?)
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

class CustomerDetailsData extends Equatable {
  final String id;
  final String customerCode;
  final String salutation;
  final String fullName;
  final String initials;
  final String onboardedDate;
  final String subtitle;
  final String mobileNo;
  final String formattedMobileNo;
  final String email;
  final CustomerContactData? contact;
  final CustomerLocationDetails? location;
  final LifetimeBusinessValue? lifetimeBusinessValue;
  final CustomerCityState? city;
  final CustomerCityState? state;
  final String cityName;
  final String stateName;
  final num totalAmount;
  final String formattedAmount;
  final int ordersCount;
  final List<HistoryFromOnboardingItem> historyFromOnboarding;
  final bool isActive;
  final String createdAt;

  const CustomerDetailsData({
    this.id = '',
    this.customerCode = '',
    this.salutation = '',
    this.fullName = '',
    this.initials = '',
    this.onboardedDate = '',
    this.subtitle = '',
    this.mobileNo = '',
    this.formattedMobileNo = '',
    this.email = '',
    this.contact,
    this.location,
    this.lifetimeBusinessValue,
    this.city,
    this.state,
    this.cityName = '',
    this.stateName = '',
    this.totalAmount = 0,
    this.formattedAmount = '',
    this.ordersCount = 0,
    this.historyFromOnboarding = const [],
    this.isActive = true,
    this.createdAt = '',
  });

  factory CustomerDetailsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerDetailsData();

    List<HistoryFromOnboardingItem> historyList = [];
    if (json['history_from_onboarding'] != null &&
        json['history_from_onboarding'] is List) {
      historyList = (json['history_from_onboarding'] as List)
          .map((e) =>
              HistoryFromOnboardingItem.fromJson(e as Map<String, dynamic>?))
          .toList();
    }

    return CustomerDetailsData(
      id: json['id']?.toString() ?? '',
      customerCode: json['customer_code']?.toString() ?? '',
      salutation: json['salutation']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      initials: json['initials']?.toString() ?? '',
      onboardedDate: json['onboarded_date']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      formattedMobileNo: json['formatted_mobile_no']?.toString() ??
          (json['mobile_no']?.toString() ?? ''),
      email: json['email']?.toString() ?? '',
      contact: json['contact'] != null
          ? CustomerContactData.fromJson(json['contact'] as Map<String, dynamic>?)
          : null,
      location: json['location'] != null
          ? CustomerLocationDetails.fromJson(
              json['location'] as Map<String, dynamic>?)
          : null,
      lifetimeBusinessValue: json['lifetime_business_value'] != null
          ? LifetimeBusinessValue.fromJson(
              json['lifetime_business_value'] as Map<String, dynamic>?)
          : null,
      city: json['city'] != null
          ? CustomerCityState.fromJson(json['city'] as Map<String, dynamic>?)
          : null,
      state: json['state'] != null
          ? CustomerCityState.fromJson(json['state'] as Map<String, dynamic>?)
          : null,
      cityName: json['city_name']?.toString() ??
          (json['city'] != null ? json['city']['title']?.toString() ?? '' : ''),
      stateName: json['state_name']?.toString() ??
          (json['state'] != null
              ? json['state']['title']?.toString() ?? ''
              : ''),
      totalAmount: json['total_amount'] as num? ??
          (json['lifetime_business_value'] != null
              ? json['lifetime_business_value']['amount'] as num? ?? 0
              : 0),
      formattedAmount: json['formatted_amount']?.toString() ??
          (json['lifetime_business_value'] != null
              ? json['lifetime_business_value']['formatted_amount']?.toString() ??
                  ''
              : ''),
      ordersCount: json['orders_count'] as int? ?? 0,
      historyFromOnboarding: historyList,
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
      'onboarded_date': onboardedDate,
      'subtitle': subtitle,
      'mobile_no': mobileNo,
      'formatted_mobile_no': formattedMobileNo,
      'email': email,
      'contact': contact?.toJson(),
      'location': location?.toJson(),
      'lifetime_business_value': lifetimeBusinessValue?.toJson(),
      'city': city?.toJson(),
      'state': state?.toJson(),
      'city_name': cityName,
      'state_name': stateName,
      'total_amount': totalAmount,
      'formatted_amount': formattedAmount,
      'orders_count': ordersCount,
      'history_from_onboarding':
          historyFromOnboarding.map((e) => e.toJson()).toList(),
      'is_active': isActive,
      'created_at': createdAt,
    };
  }

  /// Converts this data into CustomerDetailItem for UI compatibility
  CustomerDetailItem toCustomerDetailItem() {
    return CustomerDetailItem(
      id: id,
      initials: initials.isNotEmpty
          ? initials
          : (fullName.isNotEmpty ? fullName[0].toUpperCase() : 'C'),
      name: fullName.isNotEmpty ? fullName : 'Customer',
      phone: formattedMobileNo.isNotEmpty ? formattedMobileNo : mobileNo,
      city: cityName.isNotEmpty
          ? cityName
          : (location?.city?.title ?? location?.name ?? ''),
      amount: formattedAmount.isNotEmpty
          ? formattedAmount
          : '₹$totalAmount',
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
        onboardedDate,
        subtitle,
        mobileNo,
        formattedMobileNo,
        email,
        contact,
        location,
        lifetimeBusinessValue,
        city,
        state,
        cityName,
        stateName,
        totalAmount,
        formattedAmount,
        ordersCount,
        historyFromOnboarding,
        isActive,
        createdAt,
      ];
}

class CustomerContactData extends Equatable {
  final String mobileNo;
  final String rawMobileNo;
  final String email;

  const CustomerContactData({
    this.mobileNo = '',
    this.rawMobileNo = '',
    this.email = '',
  });

  factory CustomerContactData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerContactData();
    return CustomerContactData(
      mobileNo: json['mobile_no']?.toString() ?? '',
      rawMobileNo: json['raw_mobile_no']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile_no': mobileNo,
      'raw_mobile_no': rawMobileNo,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [mobileNo, rawMobileNo, email];
}

class CustomerLocationDetails extends Equatable {
  final String name;
  final CustomerCityState? city;
  final CustomerCityState? state;
  final String address;
  final String pincode;

  const CustomerLocationDetails({
    this.name = '',
    this.city,
    this.state,
    this.address = '',
    this.pincode = '',
  });

  factory CustomerLocationDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerLocationDetails();
    return CustomerLocationDetails(
      name: json['name']?.toString() ?? '',
      city: json['city'] != null
          ? CustomerCityState.fromJson(json['city'] as Map<String, dynamic>?)
          : null,
      state: json['state'] != null
          ? CustomerCityState.fromJson(json['state'] as Map<String, dynamic>?)
          : null,
      address: json['address']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city?.toJson(),
      'state': state?.toJson(),
      'address': address,
      'pincode': pincode,
    };
  }

  @override
  List<Object?> get props => [name, city, state, address, pincode];
}

class CustomerCityState extends Equatable {
  final String id;
  final String title;

  const CustomerCityState({
    this.id = '',
    this.title = '',
  });

  factory CustomerCityState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomerCityState();
    return CustomerCityState(
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

class LifetimeBusinessValue extends Equatable {
  final num amount;
  final String formattedAmount;

  const LifetimeBusinessValue({
    this.amount = 0,
    this.formattedAmount = '',
  });

  factory LifetimeBusinessValue.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LifetimeBusinessValue();
    return LifetimeBusinessValue(
      amount: json['amount'] as num? ?? 0,
      formattedAmount: json['formatted_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'formatted_amount': formattedAmount,
    };
  }

  @override
  List<Object?> get props => [amount, formattedAmount];
}

class HistoryFromOnboardingItem extends Equatable {
  final String id;
  final String type;
  final String date;
  final String timestamp;
  final String title;
  final String status;
  final String statusColor;
  final Map<String, dynamic>? details;

  const HistoryFromOnboardingItem({
    this.id = '',
    this.type = '',
    this.date = '',
    this.timestamp = '',
    this.title = '',
    this.status = '',
    this.statusColor = '',
    this.details,
  });

  factory HistoryFromOnboardingItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HistoryFromOnboardingItem();
    return HistoryFromOnboardingItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusColor: json['status_color']?.toString() ?? '',
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date,
      'timestamp': timestamp,
      'title': title,
      'status': status,
      'status_color': statusColor,
      'details': details,
    };
  }

  CustomerTimelineEvent toTimelineEvent() {
    return CustomerTimelineEvent(
      date: date,
      title: title,
      badgeText: status.isNotEmpty ? status : 'Completed',
      statusColor: statusColor.isNotEmpty ? statusColor : '#16a34a',
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        date,
        timestamp,
        title,
        status,
        statusColor,
        details,
      ];
}
