import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/dashboard_model/admin_dashboard_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class AdminDashboardParams extends Equatable {
  final String period;

  const AdminDashboardParams({this.period = 'this_week'});

  @override
  List<Object?> get props => [period];
}

class AdminDashboardUseCase
    implements UseCase<AdminDashboardResponse, AdminDashboardParams> {
  final Repository _repository;

  const AdminDashboardUseCase(this._repository);

  @override
  Future<Either<Failure, AdminDashboardResponse>> call(
    AdminDashboardParams params,
  ) async {
    return _repository.admin_dashboard(params);
  }
}
