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

  const RefundsParams({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, status, search];
}

class RefundsUseCase implements UseCase<RefundsResponse, RefundsParams> {
  final Repository _repository;

  const RefundsUseCase(this._repository);

  @override
  Future<Either<Failure, RefundsResponse>> call(RefundsParams params) {
    return _repository.refunds_list(params);
  }
}
