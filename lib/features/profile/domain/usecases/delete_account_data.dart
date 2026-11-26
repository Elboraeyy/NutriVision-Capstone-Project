import '../repositories/profile_repository.dart';

/// Permanently deletes the user's local profile and account data.
class DeleteAccountData {
  const DeleteAccountData(this._repository);

  final ProfileRepository _repository;

  Future<void> call() => _repository.deleteAccountData();
}
