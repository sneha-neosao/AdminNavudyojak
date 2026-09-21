import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/bookings_model/pending_advance_bookings_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class PendingAdvanceBookingsParams extends Equatable {
  final int page;
  final int limit;
  final String? search;

  const PendingAdvanceBookingsParams({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}

class PendingAdvanceBookingsUseCase
    implements
        UseCase<PendingAdvanceBookingsResponse, PendingAdvanceBookingsParams> {
  final Repository _repository;

  const PendingAdvanceBookingsUseCase(this._repository);

  @override
  Future<Either<Failure, PendingAdvanceBookingsResponse>> call(
    PendingAdvanceBookingsParams params,
  ) {
    return _repository.pending_advance_bookings(params);
  }
}
