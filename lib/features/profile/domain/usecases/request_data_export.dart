import '../repositories/profile_repository.dart';

/// Requests an export of the user's account and nutrition diary data.
class RequestDataExport {
  const RequestDataExport(this._repository);

  final ProfileRepository _repository;

  Future<void> call() => _repository.requestDataExport();
}
