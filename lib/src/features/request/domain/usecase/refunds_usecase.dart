import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/request_model/refunds_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class RefundsParams extends Equatable {
  final int page;
  final int limit;
  final String? status;
  final String? search;
  final String? dateFrom;
  final String? dateTo;
  final String? isDashboard;
  final String? ordering;
  final String? refundType;

  const RefundsParams({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.search,
    this.dateFrom,
    this.dateTo,
    this.isDashboard,
    this.ordering,
    this.refundType,
  });

  @override
  List<Object?> get props => [
        page,
        limit,
        status,
        search,
        dateFrom,
        dateTo,
        isDashboard,
        ordering,
        refundType,
      ];
}

class RefundsUseCase implements UseCase<RefundsResponse, RefundsParams> {
  final Repository _repository;

  const RefundsUseCase(this._repository);

  @override
  Future<Either<Failure, RefundsResponse>> call(RefundsParams params) {
    return _repository.refunds_list(params);
  }
}
