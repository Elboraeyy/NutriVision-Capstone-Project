import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_dashboard.dart';
import '../../domain/usecases/get_home_dashboard.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboard,
    this.selectedTab = 0,
    this.message,
  });

  final HomeStatus status;
  final HomeDashboard? dashboard;
  final int selectedTab;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboard? dashboard,
    int? selectedTab,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      selectedTab: selectedTab ?? this.selectedTab,
      message: message,
    );
  }
}

abstract class HomeEvent {
  const HomeEvent();
}

class HomeDashboardRequested extends HomeEvent {
  const HomeDashboardRequested();
}

class HomeTabSelected extends HomeEvent {
  const HomeTabSelected(this.index);

  final int index;
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeDashboard) : super(const HomeState()) {
    on<HomeDashboardRequested>(_onDashboardRequested);
    on<HomeTabSelected>(_onTabSelected);
  }

  final GetHomeDashboard _getHomeDashboard;

  Future<void> _onDashboardRequested(
    HomeDashboardRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, message: null));
    try {
      final dashboard = await _getHomeDashboard();
      emit(state.copyWith(status: HomeStatus.loaded, dashboard: dashboard));
    } catch (error) {
      emit(
        state.copyWith(status: HomeStatus.failure, message: error.toString()),
      );
    }
  }

  void _onTabSelected(HomeTabSelected event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }
}
