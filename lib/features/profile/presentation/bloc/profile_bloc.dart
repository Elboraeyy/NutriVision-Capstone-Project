import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';

enum ProfileStatus { initial, loading, loaded, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.message,
  });

  final ProfileStatus status;
  final UserProfile? profile;
  final String? message;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      message: message,
    );
  }
}

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested({this.userName, this.userEmail});

  final String? userName;
  final String? userEmail;
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getUserProfile) : super(const ProfileState()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  final GetUserProfile _getUserProfile;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, message: null));
    try {
      final profile = await _getUserProfile(
        userName: event.userName,
        userEmail: event.userEmail,
      );
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          profile: profile,
          message: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
