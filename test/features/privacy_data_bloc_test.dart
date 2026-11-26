import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutrivision_capstone_project/features/profile/data/datasources/privacy_data_local_datasource.dart';
import 'package:nutrivision_capstone_project/features/profile/data/models/privacy_settings_model.dart';
import 'package:nutrivision_capstone_project/features/profile/data/repositories/local_privacy_data_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/entities/privacy_settings.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/repositories/privacy_data_repository.dart';
import 'package:nutrivision_capstone_project/features/profile/domain/usecases/privacy_data_usecases.dart';
import 'package:nutrivision_capstone_project/features/profile/presentation/bloc/privacy_data_bloc.dart';

class _FakeBackendPrivacyRepository implements PrivacyDataRepository {
  PrivacySettings? _settings;
  bool shouldSucceedExport = true;
  bool shouldSucceedDelete = true;
  int exportCalls = 0;
  int deleteCalls = 0;

  @override
  Future<PrivacySettings?> getPrivacySettings() async => _settings;

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    _settings = settings;
  }

  @override
  Future<void> requestDataExport() async {
    exportCalls++;
    if (!shouldSucceedExport) {
      throw Exception('Export failed');
    }
  }

  @override
  Future<void> deleteAccount() async {
    deleteCalls++;
    if (!shouldSucceedDelete) {
      throw Exception('Delete failed');
    }
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'PrivacySettingsModel & LocalPrivacyDataRepository persist photo processing preference',
    () async {
      final repository = LocalPrivacyDataRepository(
        localDataSource: SharedPrefsPrivacyDataLocalDataSource(),
      );

      expect(await repository.getPrivacySettings(), isNull);

      const enabled = PrivacySettings(allowMealPhotoProcessing: true);
      await repository.savePrivacySettings(enabled);

      final restored = await repository.getPrivacySettings();
      expect(restored, enabled);
    },
  );

  test('PrivacySettingsModel.tryDecode returns null for corrupt JSON', () {
    expect(PrivacySettingsModel.tryDecode('bad-json'), isNull);
    expect(PrivacySettingsModel.tryDecode('[]'), isNull);
    expect(PrivacySettingsModel.tryDecode(''), isNull);
  });

  test(
    'LocalPrivacyDataRepository throws PrivacyBackendUnavailableException for export and delete',
    () async {
      final repository = LocalPrivacyDataRepository(
        localDataSource: SharedPrefsPrivacyDataLocalDataSource(),
      );

      await expectLater(
        repository.requestDataExport(),
        throwsA(isA<PrivacyBackendUnavailableException>()),
      );
      await expectLater(
        repository.deleteAccount(),
        throwsA(isA<PrivacyBackendUnavailableException>()),
      );
    },
  );

  test(
    'PrivacyDataBloc toggles and persists photo processing preference',
    () async {
      final repository = LocalPrivacyDataRepository(
        localDataSource: SharedPrefsPrivacyDataLocalDataSource(),
      );
      final bloc = PrivacyDataBloc(
        getPrivacySettings: GetPrivacySettings(repository),
        savePrivacySettings: SavePrivacySettings(repository),
        requestDataExport: RequestAccountDataExport(repository),
        deleteUserAccount: DeleteUserAccount(repository),
      );

      bloc.add(const PrivacyDataStarted());
      await bloc.stream.firstWhere((s) => s.status == PrivacyDataStatus.ready);
      expect(bloc.state.allowMealPhotoProcessing, isFalse);

      bloc.add(const MealPhotoProcessingToggled(true));
      await pumpEventQueue();
      expect(bloc.state.allowMealPhotoProcessing, isTrue);
      expect(
        (await repository.getPrivacySettings())?.allowMealPhotoProcessing,
        isTrue,
      );

      await bloc.close();
    },
  );

  test(
    'PrivacyDataBloc prevents deletion without confirmation and handles unavailable backend',
    () async {
      final repository = LocalPrivacyDataRepository(
        localDataSource: SharedPrefsPrivacyDataLocalDataSource(),
      );
      final bloc = PrivacyDataBloc(
        getPrivacySettings: GetPrivacySettings(repository),
        savePrivacySettings: SavePrivacySettings(repository),
        requestDataExport: RequestAccountDataExport(repository),
        deleteUserAccount: DeleteUserAccount(repository),
      );

      bloc.add(const PrivacyDataStarted());
      await bloc.stream.firstWhere((s) => s.status == PrivacyDataStatus.ready);

      // Cannot delete without checking confirmation.
      expect(bloc.state.canDeleteAccount, isFalse);
      bloc.add(const AccountDeletionRequested());
      await pumpEventQueue();
      expect(bloc.state.deletionStatus, AccountDeletionStatus.idle);

      // Confirm checkbox, then cancel resets confirmation.
      bloc.add(const DeletionConfirmationToggled(true));
      await pumpEventQueue();
      expect(bloc.state.canDeleteAccount, isTrue);
      bloc.add(const DeletionCancelled());
      await pumpEventQueue();
      expect(bloc.state.isDeletionConfirmed, isFalse);
      expect(bloc.state.canDeleteAccount, isFalse);

      // Confirm checkbox and attempt delete -> reports backend unavailable.
      bloc.add(const DeletionConfirmationToggled(true));
      bloc.add(const AccountDeletionRequested());
      await bloc.stream.firstWhere(
        (s) => s.deletionStatus == AccountDeletionStatus.unavailable,
      );
      expect(bloc.state.feedbackType, PrivacyFeedbackType.error);

      await bloc.close();
    },
  );

  test(
    'PrivacyDataBloc supports backend export & delete success/error when service exists',
    () async {
      final fakeRepo = _FakeBackendPrivacyRepository();
      final bloc = PrivacyDataBloc(
        getPrivacySettings: GetPrivacySettings(fakeRepo),
        savePrivacySettings: SavePrivacySettings(fakeRepo),
        requestDataExport: RequestAccountDataExport(fakeRepo),
        deleteUserAccount: DeleteUserAccount(fakeRepo),
      );

      bloc.add(const PrivacyDataStarted());
      await bloc.stream.firstWhere((s) => s.status == PrivacyDataStatus.ready);

      bloc.add(const DataExportRequested());
      await bloc.stream.firstWhere(
        (s) => s.exportStatus == DataExportStatus.succeeded,
      );
      expect(fakeRepo.exportCalls, 1);

      fakeRepo.shouldSucceedDelete = false;
      bloc.add(const DeletionConfirmationToggled(true));
      bloc.add(const AccountDeletionRequested());
      await bloc.stream.firstWhere(
        (s) => s.deletionStatus == AccountDeletionStatus.failure,
      );

      fakeRepo.shouldSucceedDelete = true;
      bloc.add(const AccountDeletionRequested());
      await bloc.stream.firstWhere(
        (s) => s.deletionStatus == AccountDeletionStatus.succeeded,
      );
      expect(fakeRepo.deleteCalls, 2);

      await bloc.close();
    },
  );
}
