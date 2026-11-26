import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/privacy_settings.dart';
import '../../domain/usecases/privacy_data_usecases.dart';

enum PrivacyDataStatus { initial, loading, ready, savingPreference, failure }

enum DataExportStatus { idle, requesting, succeeded, unavailable, failure }

enum AccountDeletionStatus { idle, deleting, succeeded, unavailable, failure }

enum PrivacyFeedbackType { success, info, warning, error }

class PrivacyDataState {
  const PrivacyDataState({
    this.status = PrivacyDataStatus.initial,
    this.savedSettings = const PrivacySettings(),
    this.isDeletionConfirmed = false,
    this.exportStatus = DataExportStatus.idle,
    this.deletionStatus = AccountDeletionStatus.idle,
    this.feedbackMessage,
    this.feedbackType,
  });

  final PrivacyDataStatus status;
  final PrivacySettings savedSettings;
  final bool isDeletionConfirmed;
  final DataExportStatus exportStatus;
  final AccountDeletionStatus deletionStatus;
  final String? feedbackMessage;
  final PrivacyFeedbackType? feedbackType;

  bool get allowMealPhotoProcessing => savedSettings.allowMealPhotoProcessing;

  bool get canDeleteAccount =>
      isDeletionConfirmed && deletionStatus != AccountDeletionStatus.deleting;

  PrivacyDataState copyWith({
    PrivacyDataStatus? status,
    PrivacySettings? savedSettings,
    bool? isDeletionConfirmed,
    DataExportStatus? exportStatus,
    AccountDeletionStatus? deletionStatus,
    String? feedbackMessage,
    PrivacyFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return PrivacyDataState(
      status: status ?? this.status,
      savedSettings: savedSettings ?? this.savedSettings,
      isDeletionConfirmed: isDeletionConfirmed ?? this.isDeletionConfirmed,
      exportStatus: exportStatus ?? this.exportStatus,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      feedbackMessage: clearFeedback ? null : feedbackMessage,
      feedbackType: clearFeedback ? null : feedbackType,
    );
  }
}

abstract class PrivacyDataEvent {
  const PrivacyDataEvent();
}

class PrivacyDataStarted extends PrivacyDataEvent {
  const PrivacyDataStarted();
}

class MealPhotoProcessingToggled extends PrivacyDataEvent {
  const MealPhotoProcessingToggled(this.enabled);

  final bool enabled;
}

class DeletionConfirmationToggled extends PrivacyDataEvent {
  const DeletionConfirmationToggled(this.confirmed);

  final bool confirmed;
}

class DeletionCancelled extends PrivacyDataEvent {
  const DeletionCancelled();
}

class DataExportRequested extends PrivacyDataEvent {
  const DataExportRequested();
}

class AccountDeletionRequested extends PrivacyDataEvent {
  const AccountDeletionRequested();
}

class PrivacyDataBloc extends Bloc<PrivacyDataEvent, PrivacyDataState> {
  PrivacyDataBloc({
    required GetPrivacySettings getPrivacySettings,
    required SavePrivacySettings savePrivacySettings,
    required RequestAccountDataExport requestDataExport,
    required DeleteUserAccount deleteUserAccount,
  }) : _getPrivacySettings = getPrivacySettings,
       _savePrivacySettings = savePrivacySettings,
       _requestDataExport = requestDataExport,
       _deleteUserAccount = deleteUserAccount,
       super(const PrivacyDataState()) {
    on<PrivacyDataStarted>(_onStarted);
    on<MealPhotoProcessingToggled>(_onPhotoProcessingToggled);
    on<DeletionConfirmationToggled>(_onDeletionConfirmationToggled);
    on<DeletionCancelled>(_onDeletionCancelled);
    on<DataExportRequested>(_onDataExportRequested);
    on<AccountDeletionRequested>(_onAccountDeletionRequested);
  }

  final GetPrivacySettings _getPrivacySettings;
  final SavePrivacySettings _savePrivacySettings;
  final RequestAccountDataExport _requestDataExport;
  final DeleteUserAccount _deleteUserAccount;

  Future<void> _onStarted(
    PrivacyDataStarted event,
    Emitter<PrivacyDataState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PrivacyDataStatus.loading,
        isDeletionConfirmed: false,
        exportStatus: DataExportStatus.idle,
        deletionStatus: AccountDeletionStatus.idle,
        clearFeedback: true,
      ),
    );
    try {
      final saved = await _getPrivacySettings();
      emit(
        state.copyWith(
          status: PrivacyDataStatus.ready,
          savedSettings: saved ?? const PrivacySettings(),
          clearFeedback: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PrivacyDataStatus.failure,
          feedbackMessage: 'Unable to load your privacy preferences.',
          feedbackType: PrivacyFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onPhotoProcessingToggled(
    MealPhotoProcessingToggled event,
    Emitter<PrivacyDataState> emit,
  ) async {
    final previous = state.savedSettings;
    final next = previous.copyWith(allowMealPhotoProcessing: event.enabled);
    emit(
      state.copyWith(
        status: PrivacyDataStatus.savingPreference,
        savedSettings: next,
        clearFeedback: true,
      ),
    );
    try {
      await _savePrivacySettings(next);
      emit(
        state.copyWith(
          status: PrivacyDataStatus.ready,
          savedSettings: next,
          feedbackMessage: 'Photo processing permission preference saved.',
          feedbackType: PrivacyFeedbackType.success,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PrivacyDataStatus.failure,
          savedSettings: previous,
          feedbackMessage: 'Could not save photo processing preference.',
          feedbackType: PrivacyFeedbackType.error,
        ),
      );
    }
  }

  void _onDeletionConfirmationToggled(
    DeletionConfirmationToggled event,
    Emitter<PrivacyDataState> emit,
  ) {
    emit(
      state.copyWith(
        isDeletionConfirmed: event.confirmed,
        deletionStatus: AccountDeletionStatus.idle,
        clearFeedback: true,
      ),
    );
  }

  void _onDeletionCancelled(
    DeletionCancelled event,
    Emitter<PrivacyDataState> emit,
  ) {
    emit(
      state.copyWith(
        isDeletionConfirmed: false,
        deletionStatus: AccountDeletionStatus.idle,
        feedbackMessage: state.isDeletionConfirmed
            ? 'Account deletion cancelled.'
            : null,
        feedbackType: state.isDeletionConfirmed
            ? PrivacyFeedbackType.info
            : null,
        clearFeedback: !state.isDeletionConfirmed,
      ),
    );
  }

  Future<void> _onDataExportRequested(
    DataExportRequested event,
    Emitter<PrivacyDataState> emit,
  ) async {
    if (state.exportStatus == DataExportStatus.requesting) return;
    emit(
      state.copyWith(
        exportStatus: DataExportStatus.requesting,
        clearFeedback: true,
      ),
    );
    try {
      await _requestDataExport();
      emit(
        state.copyWith(
          exportStatus: DataExportStatus.succeeded,
          feedbackMessage: 'Your data export request has been submitted.',
          feedbackType: PrivacyFeedbackType.success,
        ),
      );
    } on PrivacyBackendUnavailableException catch (error) {
      emit(
        state.copyWith(
          exportStatus: DataExportStatus.unavailable,
          feedbackMessage: error.message,
          feedbackType: PrivacyFeedbackType.warning,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          exportStatus: DataExportStatus.failure,
          feedbackMessage: 'Could not request a data export right now.',
          feedbackType: PrivacyFeedbackType.error,
        ),
      );
    }
  }

  Future<void> _onAccountDeletionRequested(
    AccountDeletionRequested event,
    Emitter<PrivacyDataState> emit,
  ) async {
    if (!state.isDeletionConfirmed ||
        state.deletionStatus == AccountDeletionStatus.deleting) {
      return;
    }
    emit(
      state.copyWith(
        deletionStatus: AccountDeletionStatus.deleting,
        clearFeedback: true,
      ),
    );
    try {
      await _deleteUserAccount();
      emit(
        state.copyWith(
          deletionStatus: AccountDeletionStatus.succeeded,
          feedbackMessage: 'Your account and data have been deleted.',
          feedbackType: PrivacyFeedbackType.success,
        ),
      );
    } on PrivacyBackendUnavailableException catch (error) {
      emit(
        state.copyWith(
          deletionStatus: AccountDeletionStatus.unavailable,
          feedbackMessage: error.message,
          feedbackType: PrivacyFeedbackType.error,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          deletionStatus: AccountDeletionStatus.failure,
          feedbackMessage: 'Could not delete your account. Please try again.',
          feedbackType: PrivacyFeedbackType.error,
        ),
      );
    }
  }
}
