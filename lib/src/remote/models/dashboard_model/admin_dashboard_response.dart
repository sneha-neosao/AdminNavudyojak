import 'dart:convert';
import 'package:equatable/equatable.dart';

class AdminDashboardResponse extends Equatable {
  final bool? success;
  final String? message;
  final AdminDashboardData? data;
  final dynamic errors;

  const AdminDashboardResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory AdminDashboardResponse.fromRawJson(String str) =>
      AdminDashboardResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) =>
      AdminDashboardResponse(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] != null && json["data"] is Map<String, dynamic>
            ? AdminDashboardData.fromJson(json["data"] as Map<String, dynamic>)
            : null,
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "errors": errors,
      };

  @override
  List<Object?> get props => [success, message, data, errors];
}

class AdminDashboardData extends Equatable {
  final DashboardHeader? header;
  final DashboardMetrics? metrics;
  final DashboardBusinessMovement? businessMovement;
  final DashboardReturnSettlements? returnSettlements;
  final DashboardNewCustomers? newCustomers;

  const AdminDashboardData({
    this.header,
    this.metrics,
    this.businessMovement,
    this.returnSettlements,
    this.newCustomers,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) =>
      AdminDashboardData(
        header: json["header"] != null && json["header"] is Map<String, dynamic>
            ? DashboardHeader.fromJson(json["header"] as Map<String, dynamic>)
            : null,
        metrics: json["metrics"] != null && json["metrics"] is Map<String, dynamic>
            ? DashboardMetrics.fromJson(json["metrics"] as Map<String, dynamic>)
            : null,
        businessMovement: json["business_movement"] != null &&
                json["business_movement"] is Map<String, dynamic>
            ? DashboardBusinessMovement.fromJson(
                json["business_movement"] as Map<String, dynamic>)
            : null,
        returnSettlements: json["return_settlements"] != null &&
                json["return_settlements"] is Map<String, dynamic>
            ? DashboardReturnSettlements.fromJson(
                json["return_settlements"] as Map<String, dynamic>)
            : null,
        newCustomers: json["new_customers"] != null &&
                json["new_customers"] is Map<String, dynamic>
            ? DashboardNewCustomers.fromJson(
                json["new_customers"] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "metrics": metrics?.toJson(),
        "business_movement": businessMovement?.toJson(),
        "return_settlements": returnSettlements?.toJson(),
        "new_customers": newCustomers?.toJson(),
      };

  @override
  List<Object?> get props => [
        header,
        metrics,
        businessMovement,
        returnSettlements,
        newCustomers,
      ];
}

class DashboardHeader extends Equatable {
  final String? userName;
  final String? date;
  final String? dateFormatted;
  final int? urgentAlertsCount;
  final List<dynamic>? urgentAlerts;

  const DashboardHeader({
    this.userName,
    this.date,
    this.dateFormatted,
    this.urgentAlertsCount,
    this.urgentAlerts,
  });

  factory DashboardHeader.fromJson(Map<String, dynamic> json) =>
      DashboardHeader(
        userName: json["user_name"]?.toString(),
        date: json["date"]?.toString(),
        dateFormatted: json["date_formatted"]?.toString(),
        urgentAlertsCount: (json["urgent_alerts_count"] as num?)?.toInt() ?? 0,
        urgentAlerts: json["urgent_alerts"] != null && json["urgent_alerts"] is List
            ? List<dynamic>.from(json["urgent_alerts"])
            : [],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "date": date,
        "date_formatted": dateFormatted,
        "urgent_alerts_count": urgentAlertsCount,
        "urgent_alerts": urgentAlerts,
      };

  @override
  List<Object?> get props => [
        userName,
        date,
        dateFormatted,
        urgentAlertsCount,
        urgentAlerts,
      ];
}

class DashboardMetrics extends Equatable {
  final MetricSales? sales;
  final MetricPurchases? purchases;
  final MetricRawMaterial? rawMaterial;
  final MetricFinishedProducts? finishedProducts;
  final MetricCustomers? customers;
  final MetricExpenses? expenses;

  const DashboardMetrics({
    this.sales,
    this.purchases,
    this.rawMaterial,
    this.finishedProducts,
    this.customers,
    this.expenses,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) =>
      DashboardMetrics(
        sales: json["sales"] != null && json["sales"] is Map<String, dynamic>
            ? MetricSales.fromJson(json["sales"] as Map<String, dynamic>)
            : null,
        purchases: json["purchases"] != null &&
                json["purchases"] is Map<String, dynamic>
            ? MetricPurchases.fromJson(
                json["purchases"] as Map<String, dynamic>)
            : null,
        rawMaterial: json["raw_material"] != null &&
                json["raw_material"] is Map<String, dynamic>
            ? MetricRawMaterial.fromJson(
                json["raw_material"] as Map<String, dynamic>)
            : null,
        finishedProducts: json["finished_products"] != null &&
                json["finished_products"] is Map<String, dynamic>
            ? MetricFinishedProducts.fromJson(
                json["finished_products"] as Map<String, dynamic>)
            : null,
        customers: json["customers"] != null &&
                json["customers"] is Map<String, dynamic>
            ? MetricCustomers.fromJson(
                json["customers"] as Map<String, dynamic>)
            : null,
        expenses: json["expenses"] != null &&
                json["expenses"] is Map<String, dynamic>
            ? MetricExpenses.fromJson(json["expenses"] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "sales": sales?.toJson(),
        "purchases": purchases?.toJson(),
        "raw_material": rawMaterial?.toJson(),
        "finished_products": finishedProducts?.toJson(),
        "customers": customers?.toJson(),
        "expenses": expenses?.toJson(),
      };

  @override
  List<Object?> get props => [
        sales,
        purchases,
        rawMaterial,
        finishedProducts,
        customers,
        expenses,
      ];
}

class MetricSales extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;
  final num? trendPercentage;
  final String? trendDirection;

  const MetricSales({
    this.title,
    this.value,
    this.formattedValue,
    this.trendPercentage,
    this.trendDirection,
  });

  factory MetricSales.fromJson(Map<String, dynamic> json) => MetricSales(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
        trendPercentage: json["trend_percentage"] as num?,
        trendDirection: json["trend_direction"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
        "trend_percentage": trendPercentage,
        "trend_direction": trendDirection,
      };

  @override
  List<Object?> get props => [
        title,
        value,
        formattedValue,
        trendPercentage,
        trendDirection,
      ];
}

class MetricPurchases extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;
  final int? billsCount;

  const MetricPurchases({
    this.title,
    this.value,
    this.formattedValue,
    this.billsCount,
  });

  factory MetricPurchases.fromJson(Map<String, dynamic> json) =>
      MetricPurchases(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
        billsCount: (json["bills_count"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
        "bills_count": billsCount,
      };

  @override
  List<Object?> get props => [title, value, formattedValue, billsCount];
}

class MetricRawMaterial extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;
  final num? availablePercentage;

  const MetricRawMaterial({
    this.title,
    this.value,
    this.formattedValue,
    this.availablePercentage,
  });

  factory MetricRawMaterial.fromJson(Map<String, dynamic> json) =>
      MetricRawMaterial(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
        availablePercentage: json["available_percentage"] as num?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
        "available_percentage": availablePercentage,
      };

  @override
  List<Object?> get props => [
        title,
        value,
        formattedValue,
        availablePercentage,
      ];
}

class MetricFinishedProducts extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;

  const MetricFinishedProducts({
    this.title,
    this.value,
    this.formattedValue,
  });

  factory MetricFinishedProducts.fromJson(Map<String, dynamic> json) =>
      MetricFinishedProducts(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
      };

  @override
  List<Object?> get props => [title, value, formattedValue];
}

class MetricCustomers extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;
  final int? newThisWeekCount;

  const MetricCustomers({
    this.title,
    this.value,
    this.formattedValue,
    this.newThisWeekCount,
  });

  factory MetricCustomers.fromJson(Map<String, dynamic> json) =>
      MetricCustomers(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
        newThisWeekCount: (json["new_this_week_count"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
        "new_this_week_count": newThisWeekCount,
      };

  @override
  List<Object?> get props => [
        title,
        value,
        formattedValue,
        newThisWeekCount,
      ];
}

class MetricExpenses extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;
  final num? percentageOfSales;

  const MetricExpenses({
    this.title,
    this.value,
    this.formattedValue,
    this.percentageOfSales,
  });

  factory MetricExpenses.fromJson(Map<String, dynamic> json) => MetricExpenses(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
        percentageOfSales: json["percentage_of_sales"] as num?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
        "percentage_of_sales": percentageOfSales,
      };

  @override
  List<Object?> get props => [
        title,
        value,
        formattedValue,
        percentageOfSales,
      ];
}

class DashboardBusinessMovement extends Equatable {
  final String? period;
  final String? granularity;
  final List<DailyBreakdownItem>? dailyBreakdown;
  final BusinessMovementSummary? summary;

  const DashboardBusinessMovement({
    this.period,
    this.granularity,
    this.dailyBreakdown,
    this.summary,
  });

  factory DashboardBusinessMovement.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json["daily_breakdown"] ??
        json["weekly_breakdown"] ??
        json["monthly_breakdown"] ??
        json["breakdown"] ??
        json["chart_data"] ??
        json["data"] ??
        json["items"];
    return DashboardBusinessMovement(
      period: json["period"]?.toString(),
      granularity: (json["granularity"] ?? json["period"])?.toString(),
      dailyBreakdown: rawBreakdown != null && rawBreakdown is List
          ? rawBreakdown
              .whereType<Map<String, dynamic>>()
              .map((x) => DailyBreakdownItem.fromJson(x))
              .toList()
          : [],
      summary: json["summary"] != null &&
              json["summary"] is Map<String, dynamic>
          ? BusinessMovementSummary.fromJson(
              json["summary"] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "period": period,
        "granularity": granularity,
        "daily_breakdown": dailyBreakdown?.map((x) => x.toJson()).toList(),
        "summary": summary?.toJson(),
      };

  @override
  List<Object?> get props => [period, granularity, dailyBreakdown, summary];
}

class DailyBreakdownItem extends Equatable {
  final String? dayShort;
  final String? dayName;
  final String? date;
  final num? sales;
  final num? purchases;
  final num? production;
  final num? expenses;

  const DailyBreakdownItem({
    this.dayShort,
    this.dayName,
    this.date,
    this.sales,
    this.purchases,
    this.production,
    this.expenses,
  });

  factory DailyBreakdownItem.fromJson(Map<String, dynamic> json) =>
      DailyBreakdownItem(
        dayShort: (json["day_short"] ??
                json["short_name"] ??
                json["label"] ??
                json["week"] ??
                json["week_short"] ??
                json["week_number"] ??
                json["month"] ??
                json["month_short"] ??
                json["month_name"] ??
                json["name"] ??
                json["title"] ??
                json["day"])
            ?.toString(),
        dayName: (json["day_name"] ??
                json["name"] ??
                json["title"] ??
                json["week_name"] ??
                json["month_name"] ??
                json["full_name"] ??
                json["label"])
            ?.toString(),
        date: (json["date"] ?? json["created_at"])?.toString(),
        sales: _parseNum(
          json["sales"] ??
              json["total_sales"] ??
              json["sales_value"] ??
              json["value"] ??
              json["amount"],
        ),
        purchases: _parseNum(
          json["purchases"] ??
              json["total_purchases"] ??
              json["purchase_value"],
        ),
        production: _parseNum(
          json["production"] ??
              json["total_production"] ??
              json["production_value"] ??
              json["count"],
        ),
        expenses: _parseNum(
          json["expenses"] ??
              json["total_expenses"] ??
              json["expense_value"],
        ),
      );

  static num _parseNum(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val;
    return num.tryParse(val.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        "day_short": dayShort,
        "day_name": dayName,
        "date": date,
        "sales": sales,
        "purchases": purchases,
        "production": production,
        "expenses": expenses,
      };

  @override
  List<Object?> get props => [
        dayShort,
        dayName,
        date,
        sales,
        purchases,
        production,
        expenses,
      ];
}

class BusinessMovementSummary extends Equatable {
  final MovementSummaryItem? sales;
  final MovementSummaryItem? production;
  final MovementSummaryItem? expenses;

  const BusinessMovementSummary({
    this.sales,
    this.production,
    this.expenses,
  });

  factory BusinessMovementSummary.fromJson(Map<String, dynamic> json) =>
      BusinessMovementSummary(
        sales: json["sales"] != null && json["sales"] is Map<String, dynamic>
            ? MovementSummaryItem.fromJson(json["sales"] as Map<String, dynamic>)
            : null,
        production: json["production"] != null &&
                json["production"] is Map<String, dynamic>
            ? MovementSummaryItem.fromJson(
                json["production"] as Map<String, dynamic>)
            : null,
        expenses: json["expenses"] != null &&
                json["expenses"] is Map<String, dynamic>
            ? MovementSummaryItem.fromJson(
                json["expenses"] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "sales": sales?.toJson(),
        "production": production?.toJson(),
        "expenses": expenses?.toJson(),
      };

  @override
  List<Object?> get props => [sales, production, expenses];
}

class MovementSummaryItem extends Equatable {
  final String? title;
  final num? value;
  final String? formattedValue;

  const MovementSummaryItem({
    this.title,
    this.value,
    this.formattedValue,
  });

  factory MovementSummaryItem.fromJson(Map<String, dynamic> json) =>
      MovementSummaryItem(
        title: json["title"]?.toString(),
        value: json["value"] as num?,
        formattedValue: json["formatted_value"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "formatted_value": formattedValue,
      };

  @override
  List<Object?> get props => [title, value, formattedValue];
}

class DashboardReturnSettlements extends Equatable {
  final int? pendingCount;
  final List<ReturnSettlementItemData>? items;
  final int? totalCount;

  const DashboardReturnSettlements({
    this.pendingCount,
    this.items,
    this.totalCount,
  });

  factory DashboardReturnSettlements.fromJson(Map<String, dynamic> json) =>
      DashboardReturnSettlements(
        pendingCount: (json["pending_count"] as num?)?.toInt() ?? 0,
        items: json["items"] != null && json["items"] is List
            ? (json["items"] as List)
                .map((x) =>
                    ReturnSettlementItemData.fromJson(x as Map<String, dynamic>))
                .toList()
            : [],
        totalCount: (json["total_count"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "pending_count": pendingCount,
        "items": items?.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
      };

  @override
  List<Object?> get props => [pendingCount, items, totalCount];
}

class ReturnSettlementItemData extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? amount;
  final String? formattedAmount;
  final String? customerName;

  const ReturnSettlementItemData({
    this.id,
    this.name,
    this.code,
    this.description,
    this.amount,
    this.formattedAmount,
    this.customerName,
  });

  factory ReturnSettlementItemData.fromJson(Map<String, dynamic> json) =>
      ReturnSettlementItemData(
        id: json["id"]?.toString(),
        name: (json["name"] ?? json["customer_name"] ?? json["full_name"])?.toString(),
        code: (json["code"] ?? json["request_number"] ?? json["settlement_code"])?.toString(),
        description: json["description"]?.toString(),
        amount: json["amount"]?.toString(),
        formattedAmount: (json["formatted_amount"] ?? json["amount"])?.toString(),
        customerName: json["customer_name"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "customer_name": customerName,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        amount,
        formattedAmount,
        customerName,
      ];
}

class DashboardNewCustomers extends Equatable {
  final int? newThisWeekCount;
  final List<NewCustomerItemData>? items;
  final int? totalCount;

  const DashboardNewCustomers({
    this.newThisWeekCount,
    this.items,
    this.totalCount,
  });

  factory DashboardNewCustomers.fromJson(Map<String, dynamic> json) =>
      DashboardNewCustomers(
        newThisWeekCount: (json["new_this_week_count"] as num?)?.toInt() ?? 0,
        items: json["items"] != null && json["items"] is List
            ? (json["items"] as List)
                .map((x) =>
                    NewCustomerItemData.fromJson(x as Map<String, dynamic>))
                .toList()
            : [],
        totalCount: (json["total_count"] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "new_this_week_count": newThisWeekCount,
        "items": items?.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
      };

  @override
  List<Object?> get props => [newThisWeekCount, items, totalCount];
}

class NewCustomerItemData extends Equatable {
  final String? id;
  final String? fullName;
  final String? initials;
  final String? cityName;
  final NewCustomerCity? city;
  final String? relativeTime;
  final String? locationTimeLabel;
  final num? lifetimeValue;
  final String? formattedLifetimeValue;
  final String? createdAt;

  const NewCustomerItemData({
    this.id,
    this.fullName,
    this.initials,
    this.cityName,
    this.city,
    this.relativeTime,
    this.locationTimeLabel,
    this.lifetimeValue,
    this.formattedLifetimeValue,
    this.createdAt,
  });

  factory NewCustomerItemData.fromJson(Map<String, dynamic> json) =>
      NewCustomerItemData(
        id: json["id"]?.toString(),
        fullName: json["full_name"]?.toString(),
        initials: json["initials"]?.toString(),
        cityName: json["city_name"]?.toString(),
        city: json["city"] != null && json["city"] is Map<String, dynamic>
            ? NewCustomerCity.fromJson(json["city"] as Map<String, dynamic>)
            : null,
        relativeTime: json["relative_time"]?.toString(),
        locationTimeLabel: json["location_time_label"]?.toString(),
        lifetimeValue: json["lifetime_value"] as num?,
        formattedLifetimeValue: json["formatted_lifetime_value"]?.toString(),
        createdAt: json["created_at"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "initials": initials,
        "city_name": cityName,
        "city": city?.toJson(),
        "relative_time": relativeTime,
        "location_time_label": locationTimeLabel,
        "lifetime_value": lifetimeValue,
        "formatted_lifetime_value": formattedLifetimeValue,
        "created_at": createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        fullName,
        initials,
        cityName,
        city,
        relativeTime,
        locationTimeLabel,
        lifetimeValue,
        formattedLifetimeValue,
        createdAt,
      ];
}

class NewCustomerCity extends Equatable {
  final String? id;
  final String? title;

  const NewCustomerCity({this.id, this.title});

  factory NewCustomerCity.fromJson(Map<String, dynamic> json) =>
      NewCustomerCity(
        id: json["id"]?.toString(),
        title: json["title"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };

  @override
  List<Object?> get props => [id, title];
}
