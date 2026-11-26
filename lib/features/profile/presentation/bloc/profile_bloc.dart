import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/delete_account_data.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/request_data_export.dart';
import '../../domain/usecases/update_goals_and_preferences.dart';
import '../../domain/usecases/update_notification_preferences.dart';
import '../../domain/usecases/update_privacy_preferences.dart';

enum ProfileLoadStatus { initial, loading, ready, failure }

enum ProfileActionStatus {
  none,
  saving,
  goalsSaved,
  notificationsSaved,
  privacySaved,
  exportRequested,
  accountDeleted,
  failure,
}

class ProfileState {
  const ProfileState({
    this.loadStatus = ProfileLoadStatus.initial,
    this.actionStatus = ProfileActionStatus.none,
    this.profile = const UserProfile(),
    this.message,
    this.actionNonce = 0,
  });

  final ProfileLoadStatus loadStatus;
  final ProfileActionStatus actionStatus;
  final UserProfile profile;
  final String? message;
  final int actionNonce;

  bool get isSaving => actionStatus == ProfileActionStatus.saving;

  ProfileState copyWith({
    ProfileLoadStatus? loadStatus,
    ProfileActionStatus? actionStatus,
    UserProfile? profile,
    String? message,
    bool clearMessage = false,
    int? actionNonce,
  }) {
    return ProfileState(
      loadStatus: loadStatus ?? this.loadStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      profile: profile ?? this.profile,
      message: clearMessage ? null : (message ?? this.message),
      actionNonce: actionNonce ?? this.actionNonce,
    );
  }
}

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

final class ProfileGoalsAndPreferencesSaved extends ProfileEvent {
  const ProfileGoalsAndPreferencesSaved(this.profile);

  final UserProfile profile;
}

final class ProfileNotificationsSaved extends ProfileEvent {
  const ProfileNotificationsSaved(this.notifications);

  final NotificationPreferences notifications;
}

final class ProfileMealPhotoConsentToggled extends ProfileEvent {
  const ProfileMealPhotoConsentToggled(this.allowed);

  final bool allowed;
}

final class ProfileDataExportRequested extends ProfileEvent {
  const ProfileDataExportRequested();
}

final class ProfileAccountDeletionRequested extends ProfileEvent {
  const ProfileAccountDeletionRequested();
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetUserProfile getUserProfile,
    required UpdateGoalsAndPreferences updateGoalsAndPreferences,
    required UpdateNotificationPreferences updateNotificationPreferences,
    required UpdatePrivacyPreferences updatePrivacyPreferences,
    required RequestDataExport requestDataExport,
    required DeleteAccountData deleteAccountData,
  }) : _getUserProfile = getUserProfile,
       _updateGoalsAndPreferences = updateGoalsAndPreferences,
       _updateNotificationPreferences = updateNotificationPreferences,
       _updatePrivacyPreferences = updatePrivacyPreferences,
       _requestDataExport = requestDataExport,
       _deleteAccountData = deleteAccountData,
       super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileGoalsAndPreferencesSaved>(_onGoalsAndPreferencesSaved);
    on<ProfileNotificationsSaved>(_onNotificationsSaved);
    on<ProfileMealPhotoConsentToggled>(_onMealPhotoConsentToggled);
    on<ProfileDataExportRequested>(_onDataExportRequested);
    on<ProfileAccountDeletionRequested>(_onAccountDeletionRequested);
  }

  final GetUserProfile _getUserProfile;
  final UpdateGoalsAndPreferences _updateGoalsAndPreferences;
  final UpdateNotificationPreferences _updateNotificationPreferences;
  final UpdatePrivacyPreferences _updatePrivacyPreferences;
  final RequestDataExport _requestDataExport;
  final DeleteAccountData _deleteAccountData;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        loadStatus: ProfileLoadStatus.loading,
        actionStatus: ProfileActionStatus.none,
        clearMessage: true,
      ),
    );
    try {
      final profile = await _getUserProfile();
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.none,
          profile: profile,
          clearMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.failure,
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  Future<void> _onGoalsAndPreferencesSaved(
    ProfileGoalsAndPreferencesSaved event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      final saved = await _updateGoalsAndPreferences(event.profile);
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.goalsSaved,
          profile: saved,
          message: 'Goals & preferences saved.',
          actionNonce: state.actionNonce + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  Future<void> _onNotificationsSaved(
    ProfileNotificationsSaved event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      final saved = await _updateNotificationPreferences(event.notifications);
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.notificationsSaved,
          profile: saved,
          message: 'Notification settings saved.',
          actionNonce: state.actionNonce + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  Future<void> _onMealPhotoConsentToggled(
    ProfileMealPhotoConsentToggled event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      final updatedPrivacy = state.profile.privacy.copyWith(
        allowMealPhotoProcessing: event.allowed,
      );
      final saved = await _updatePrivacyPreferences(updatedPrivacy);
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.privacySaved,
          profile: saved,
          clearMessage: true,
          actionNonce: state.actionNonce + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  Future<void> _onDataExportRequested(
    ProfileDataExportRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      await _requestDataExport();
      final refreshed = await _getUserProfile();
      emit(
        state.copyWith(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.exportRequested,
          profile: refreshed,
          message: 'Your data export request has been queued.',
          actionNonce: state.actionNonce + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  Future<void> _onAccountDeletionRequested(
    ProfileAccountDeletionRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.saving,
        clearMessage: true,
      ),
    );
    try {
      await _deleteAccountData();
      emit(
        ProfileState(
          loadStatus: ProfileLoadStatus.ready,
          actionStatus: ProfileActionStatus.accountDeleted,
          profile: const UserProfile(),
          message: 'Your account and local diary data were deleted.',
          actionNonce: state.actionNonce + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          message: _formatError(error),
          actionNonce: state.actionNonce + 1,
        ),
      );
    }
  }

  String _formatError(Object error) {
    if (error is ArgumentError && error.message != null) {
      return error.message.toString();
    }
    return error.toString();
  }
}
