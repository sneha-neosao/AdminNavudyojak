import 'package:equatable/equatable.dart';

class ProfileDetailsResponse extends Equatable {
  final bool? success;
  final String? message;
  final ProfileDetailsData? data;
  final dynamic errors;

  const ProfileDetailsResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileDetailsResponse();
    return ProfileDetailsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ProfileDetailsData.fromJson(json['data'] as Map<String, dynamic>)
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

class ProfileDetailsData extends Equatable {
  final String id;
  final String email;
  final String? salutation;
  final String fullName;
  final String? mobileNumber;
  final String? address;
  final String? profilePhotoUrl;
  final ProfileRole? role;
  final ProfileBranch? branch;
  final ProfileDepartment? department;
  final String? designation;
  final List<dynamic> documents;
  final bool hasSubordinatesByRole;
  final ProfileEmployee? employee;

  const ProfileDetailsData({
    this.id = '',
    this.email = '',
    this.salutation,
    this.fullName = '',
    this.mobileNumber,
    this.address,
    this.profilePhotoUrl,
    this.role,
    this.branch,
    this.department,
    this.designation,
    this.documents = const [],
    this.hasSubordinatesByRole = false,
    this.employee,
  });

  factory ProfileDetailsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileDetailsData();
    return ProfileDetailsData(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      salutation: json['salutation'] as String?,
      fullName: json['full_name'] as String? ?? '',
      mobileNumber: json['mobile_number'] as String?,
      address: json['address'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      role: json['role'] != null && json['role'] is Map<String, dynamic>
          ? ProfileRole.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      branch: json['branch'] != null && json['branch'] is Map<String, dynamic>
          ? ProfileBranch.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      department: json['department'] != null && json['department'] is Map<String, dynamic>
          ? ProfileDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      designation: json['designation'] as String?,
      documents: json['documents'] is List ? (json['documents'] as List) : const [],
      hasSubordinatesByRole: json['has_subordinates_by_role'] as bool? ?? false,
      employee: json['employee'] != null && json['employee'] is Map<String, dynamic>
          ? ProfileEmployee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'salutation': salutation,
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'address': address,
      'profile_photo_url': profilePhotoUrl,
      'role': role?.toJson(),
      'branch': branch?.toJson(),
      'department': department?.toJson(),
      'designation': designation,
      'documents': documents,
      'has_subordinates_by_role': hasSubordinatesByRole,
      'employee': employee?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        salutation,
        fullName,
        mobileNumber,
        address,
        profilePhotoUrl,
        role,
        branch,
        department,
        designation,
        documents,
        hasSubordinatesByRole,
        employee,
      ];
}

class ProfileRole extends Equatable {
  final String id;
  final String name;
  final String description;
  final ProfileCreatedBy? createdBy;
  final dynamic reportingTo;
  final ProfileDepartment? department;
  final bool systemDefault;

  const ProfileRole({
    this.id = '',
    this.name = '',
    this.description = '',
    this.createdBy,
    this.reportingTo,
    this.department,
    this.systemDefault = false,
  });

  factory ProfileRole.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileRole();
    return ProfileRole(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdBy: json['created_by'] != null && json['created_by'] is Map<String, dynamic>
          ? ProfileCreatedBy.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      reportingTo: json['reporting_to'],
      department: json['department'] != null && json['department'] is Map<String, dynamic>
          ? ProfileDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      systemDefault: json['system_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_by': createdBy?.toJson(),
      'reporting_to': reportingTo,
      'department': department?.toJson(),
      'system_default': systemDefault,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        createdBy,
        reportingTo,
        department,
        systemDefault,
      ];
}

class ProfileCreatedBy extends Equatable {
  final String? id;
  final String fullName;
  final String? email;
  final String? profilePhotoUrl;
  final dynamic department;
  final dynamic role;

  const ProfileCreatedBy({
    this.id,
    this.fullName = '',
    this.email,
    this.profilePhotoUrl,
    this.department,
    this.role,
  });

  factory ProfileCreatedBy.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileCreatedBy();
    return ProfileCreatedBy(
      id: json['id'] as String?,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      department: json['department'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'department': department,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        profilePhotoUrl,
        department,
        role,
      ];
}

class ProfileDepartment extends Equatable {
  final String id;
  final String name;

  const ProfileDepartment({
    this.id = '',
    this.name = '',
  });

  factory ProfileDepartment.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileDepartment();
    return ProfileDepartment(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
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

class ProfileBranch extends Equatable {
  final String id;
  final String name;

  const ProfileBranch({
    this.id = '',
    this.name = '',
  });

  factory ProfileBranch.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileBranch();
    return ProfileBranch(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
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

class ProfileEmployee extends Equatable {
  final String id;
  final String employeeCode;
  final String fullName;
  final String email;
  final String mobileNumber;
  final dynamic entity;
  final dynamic entityType;

  const ProfileEmployee({
    this.id = '',
    this.employeeCode = '',
    this.fullName = '',
    this.email = '',
    this.mobileNumber = '',
    this.entity,
    this.entityType,
  });

  factory ProfileEmployee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileEmployee();
    return ProfileEmployee(
      id: json['id'] as String? ?? '',
      employeeCode: json['employee_code'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobileNumber: json['mobile_number'] as String? ?? '',
      entity: json['entity'],
      entityType: json['entity_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'full_name': fullName,
      'email': email,
      'mobile_number': mobileNumber,
      'entity': entity,
      'entity_type': entityType,
    };
  }

  @override
  List<Object?> get props => [
        id,
        employeeCode,
        fullName,
        email,
        mobileNumber,
        entity,
        entityType,
      ];
}
