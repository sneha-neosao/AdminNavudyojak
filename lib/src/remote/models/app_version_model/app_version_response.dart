import 'package:equatable/equatable.dart';

class AppVersionResponse extends Equatable {
  final bool? success;
  final String? message;
  final AppVersionData? data;
  final dynamic errors;

  const AppVersionResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AppVersionResponse();
    return AppVersionResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? AppVersionData.fromJson(json['data'] as Map<String, dynamic>?)
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

class AppVersionData extends Equatable {
  final int id;
  final String appName;
  final String currentVersion;
  final String minRequiredVersion;
  final bool isMaintenanceMode;
  final String maintenanceMessage;
  final String updateUrl;
  final String createdAt;
  final String updatedAt;

  const AppVersionData({
    this.id = 0,
    this.appName = '',
    this.currentVersion = '',
    this.minRequiredVersion = '',
    this.isMaintenanceMode = false,
    this.maintenanceMessage = '',
    this.updateUrl = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory AppVersionData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AppVersionData();
    return AppVersionData(
      id: json['id'] as int? ?? 0,
      appName: json['app_name']?.toString() ?? '',
      currentVersion: json['current_version']?.toString() ?? '',
      minRequiredVersion: json['min_required_version']?.toString() ?? '',
      isMaintenanceMode: json['is_maintenance_mode'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message']?.toString() ?? '',
      updateUrl: json['update_url']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_name': appName,
      'current_version': currentVersion,
      'min_required_version': minRequiredVersion,
      'is_maintenance_mode': isMaintenanceMode,
      'maintenance_message': maintenanceMessage,
      'update_url': updateUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        appName,
        currentVersion,
        minRequiredVersion,
        isMaintenanceMode,
        maintenanceMessage,
        updateUrl,
        createdAt,
        updatedAt,
      ];
}
