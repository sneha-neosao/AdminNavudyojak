import 'package:equatable/equatable.dart';

class ApprovePendingAdvanceResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const ApprovePendingAdvanceResponse({
    this.success = false,
    this.message = '',
    this.data,
    this.errors,
  });

  factory ApprovePendingAdvanceResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ApprovePendingAdvanceResponse();
    return ApprovePendingAdvanceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors];
}
