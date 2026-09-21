import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/bookings_model/pending_advance_booking_details_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class PendingAdvanceBookingDetailsUseCase
    implements UseCase<PendingAdvanceBookingDetailsResponse, String> {
  final Repository _repository;

  const PendingAdvanceBookingDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, PendingAdvanceBookingDetailsResponse>> call(
    String params,
  ) {
    return _repository.pending_advance_booking_details(params);
  }
}
