import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe response model representing the Business Performance Analytics API response adhering to Rule 12.
class BusinessPerformanceResponse extends Equatable {
  final bool? success;
  final String? message;
  final BusinessPerformanceData? data;
  final dynamic errors;

  const BusinessPerformanceResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory BusinessPerformanceResponse.fromRawJson(String str) {
    try {
      return BusinessPerformanceResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const BusinessPerformanceResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory BusinessPerformanceResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BusinessPerformanceResponse();
    return BusinessPerformanceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? BusinessPerformanceData.fromJson(
              json['data'] as Map<String, dynamic>?,
            )
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
        'errors': errors,
      };

  @override
  List<Object?> get props => [success, message, data, errors];
}

class BusinessPerformanceData extends Equatable {
  final SummaryCardsData? summaryCards;
  final RevenueAndMarginData? revenueAndMargin;
  final List<OwnerScorecardItem> ownerScorecard;

  const BusinessPerformanceData({
    this.summaryCards,
    this.revenueAndMargin,
    this.ownerScorecard = const [],
  });

  factory BusinessPerformanceData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BusinessPerformanceData();
    return BusinessPerformanceData(
      summaryCards: json['summary_cards'] != null
          ? SummaryCardsData.fromJson(
              json['summary_cards'] as Map<String, dynamic>?,
            )
          : null,
      revenueAndMargin: json['revenue_and_margin'] != null
          ? RevenueAndMarginData.fromJson(
              json['revenue_and_margin'] as Map<String, dynamic>?,
            )
          : null,
      ownerScorecard: (json['owner_scorecard'] as List<dynamic>?)
              ?.map(
                (e) => OwnerScorecardItem.fromJson(e as Map<String, dynamic>?),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'summary_cards': summaryCards?.toJson(),
        'revenue_and_margin': revenueAndMargin?.toJson(),
        'owner_scorecard': ownerScorecard.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [summaryCards, revenueAndMargin, ownerScorecard];
}

class SummaryCardsData extends Equatable {
  final MetricCardItem? revenue;
  final MetricCardItem? ordersFulfilled;
  final MetricCardItem? activeCustomers;

  const SummaryCardsData({
    this.revenue,
    this.ordersFulfilled,
    this.activeCustomers,
  });

  factory SummaryCardsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SummaryCardsData();
    return SummaryCardsData(
      revenue: json['revenue'] != null
          ? MetricCardItem.fromJson(json['revenue'] as Map<String, dynamic>?)
          : null,
      ordersFulfilled: json['orders_fulfilled'] != null
          ? MetricCardItem.fromJson(
              json['orders_fulfilled'] as Map<String, dynamic>?,
            )
          : null,
      activeCustomers: json['active_customers'] != null
          ? MetricCardItem.fromJson(
              json['active_customers'] as Map<String, dynamic>?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'revenue': revenue?.toJson(),
        'orders_fulfilled': ordersFulfilled?.toJson(),
        'active_customers': activeCustomers?.toJson(),
      };

  @override
  List<Object?> get props => [revenue, ordersFulfilled, activeCustomers];
}

class MetricCardItem extends Equatable {
  final String title;
  final num value;
  final num trendPercentage;
  final String trendDirection;

  const MetricCardItem({
    this.title = '',
    this.value = 0,
    this.trendPercentage = 0,
    this.trendDirection = 'up',
  });

  factory MetricCardItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MetricCardItem();
    return MetricCardItem(
      title: json['title']?.toString() ?? '',
      value: json['value'] as num? ?? 0,
      trendPercentage: json['trend_percentage'] as num? ?? 0,
      trendDirection: json['trend_direction']?.toString() ?? 'up',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'value': value,
        'trend_percentage': trendPercentage,
        'trend_direction': trendDirection,
      };

  bool get isPositiveTrend => trendDirection.toLowerCase() == 'up';

  String get trendText {
    final arrow = isPositiveTrend ? '↗ +' : '↘ -';
    final formattedPercent = trendPercentage % 1 == 0
        ? trendPercentage.toInt().toString()
        : trendPercentage.toStringAsFixed(1);
    return '$arrow$formattedPercent%';
  }

  String formatValue({bool isCurrency = false}) {
    if (isCurrency) {
      if (value >= 10000000) {
        final cr = value / 10000000;
        return '₹${cr % 1 == 0 ? cr.toInt() : cr.toStringAsFixed(2)}Cr';
      } else if (value >= 100000) {
        final lakh = value / 100000;
        return '₹${lakh % 1 == 0 ? lakh.toInt() : lakh.toStringAsFixed(2)}L';
      } else if (value >= 1000) {
        final k = value / 1000;
        return '₹${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
      }
      return '₹$value';
    } else {
      if (value >= 100000) {
        final lakh = value / 100000;
        return '${lakh % 1 == 0 ? lakh.toInt() : lakh.toStringAsFixed(2)}L';
      } else if (value >= 1000) {
        final k = value / 1000;
        return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
      }
      return '$value';
    }
  }

  @override
  List<Object?> get props => [title, value, trendPercentage, trendDirection];
}

class RevenueAndMarginData extends Equatable {
  final String title;
  final String subtitle;
  final num grossMargin;
  final num targetMargin;
  final num targetVariance;
  final String targetStatus;
  final List<MonthlyDataPoint> monthlyData;

  const RevenueAndMarginData({
    this.title = '',
    this.subtitle = '',
    this.grossMargin = 0,
    this.targetMargin = 0,
    this.targetVariance = 0,
    this.targetStatus = '',
    this.monthlyData = const [],
  });

  factory RevenueAndMarginData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RevenueAndMarginData();
    return RevenueAndMarginData(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      grossMargin: json['gross_margin'] as num? ?? 0,
      targetMargin: json['target_margin'] as num? ?? 0,
      targetVariance: json['target_variance'] as num? ?? 0,
      targetStatus: json['target_status']?.toString() ?? '',
      monthlyData: (json['monthly_data'] as List<dynamic>?)
              ?.map(
                (e) => MonthlyDataPoint.fromJson(e as Map<String, dynamic>?),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'gross_margin': grossMargin,
        'target_margin': targetMargin,
        'target_variance': targetVariance,
        'target_status': targetStatus,
        'monthly_data': monthlyData.map((e) => e.toJson()).toList(),
      };

  bool get isBelowTarget =>
      targetStatus.toLowerCase() == 'below_target' || targetVariance < 0;

  String get formattedStatusBadge {
    final varianceVal = targetVariance.abs();
    final formattedVal = varianceVal % 1 == 0
        ? varianceVal.toInt().toString()
        : varianceVal.toStringAsFixed(1);
    if (isBelowTarget) {
      return '$formattedVal% below target';
    } else {
      return '$formattedVal% above target';
    }
  }

  String get formattedGrossMargin {
    return grossMargin % 1 == 0
        ? '${grossMargin.toInt()}%'
        : '${grossMargin.toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [
        title,
        subtitle,
        grossMargin,
        targetMargin,
        targetVariance,
        targetStatus,
        monthlyData,
      ];
}

class MonthlyDataPoint extends Equatable {
  final int month;
  final String monthName;
  final num revenue;
  final num marginPercentage;

  const MonthlyDataPoint({
    this.month = 0,
    this.monthName = '',
    this.revenue = 0,
    this.marginPercentage = 0,
  });

  factory MonthlyDataPoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MonthlyDataPoint();
    return MonthlyDataPoint(
      month: json['month'] as int? ?? 0,
      monthName: json['month_name']?.toString() ?? '',
      revenue: json['revenue'] as num? ?? 0,
      marginPercentage: json['margin_percentage'] as num? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month,
        'month_name': monthName,
        'revenue': revenue,
        'margin_percentage': marginPercentage,
      };

  @override
  List<Object?> get props => [month, monthName, revenue, marginPercentage];
}

class OwnerScorecardItem extends Equatable {
  final String id;
  final String title;
  final num value;
  final String status;
  final String statusVariant;

  const OwnerScorecardItem({
    this.id = '',
    this.title = '',
    this.value = 0,
    this.status = '',
    this.statusVariant = '',
  });

  factory OwnerScorecardItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OwnerScorecardItem();
    return OwnerScorecardItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: json['value'] as num? ?? 0,
      status: json['status']?.toString() ?? '',
      statusVariant: json['status_variant']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'value': value,
        'status': status,
        'status_variant': statusVariant,
      };

  bool get isSuccess =>
      statusVariant.toLowerCase() == 'success' ||
      status.toLowerCase() == 'healthy';

  bool get isDanger =>
      statusVariant.toLowerCase() == 'danger' ||
      status.toLowerCase() == 'action';

  bool get isWarning =>
      statusVariant.toLowerCase() == 'warning' ||
      status.toLowerCase() == 'watch';

  String get displayValue {
    if (id == 'low_stock_exposure') {
      if (value == 0) return '₹0';
      if (value >= 100000) {
        final lakh = value / 100000;
        return '₹${lakh % 1 == 0 ? lakh.toInt() : lakh.toStringAsFixed(1)}L';
      }
      return '₹$value';
    }
    // Default percentage format for efficiency, fulfilment, rate
    return value % 1 == 0 ? '${value.toInt()}%' : '${value.toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [id, title, value, status, statusVariant];
}
