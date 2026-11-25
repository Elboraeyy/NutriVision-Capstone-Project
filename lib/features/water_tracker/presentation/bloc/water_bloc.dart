import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_water.dart';
import '../../domain/usecases/get_today_water.dart';
import 'water_event.dart';
import 'water_state.dart';

export 'water_event.dart';
export 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  WaterBloc({required GetTodayWater getTodayWater, required AddWater addWater})
    : _getTodayWater = getTodayWater,
      _addWater = addWater,
      super(const WaterState()) {
    on<WaterTrackerStarted>(_onStarted);
    on<WaterAdded>(_onWaterAdded);
    on<QuickAddPresetSelected>(_onQuickAddPresetSelected);
    on<WaterResetRequested>(_onResetRequested);
  }

  final GetTodayWater _getTodayWater;
  final AddWater _addWater;

  Future<void> _onStarted(
    WaterTrackerStarted event,
    Emitter<WaterState> emit,
  ) async {
    emit(state.copyWith(status: WaterStatus.loading));
    try {
      final water = await _getTodayWater();
      emit(state.copyWith(status: WaterStatus.loaded, water: water));
    } catch (e) {
      emit(state.copyWith(status: WaterStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onWaterAdded(WaterAdded event, Emitter<WaterState> emit) async {
    if (event.amountMl <= 0) return;
    final isQuickAdd =
        event.amountMl == 150 || event.amountMl == 250 || event.amountMl == 500;
    try {
      final updated = await _addWater(event.amountMl);
      emit(
        state.copyWith(
          status: WaterStatus.loaded,
          water: updated,
          selectedQuickAddMl: isQuickAdd
              ? event.amountMl
              : state.selectedQuickAddMl,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WaterStatus.failure, message: e.toString()));
    }
  }

  void _onQuickAddPresetSelected(
    QuickAddPresetSelected event,
    Emitter<WaterState> emit,
  ) {
    emit(state.copyWith(selectedQuickAddMl: event.amountMl));
  }

  Future<void> _onResetRequested(
    WaterResetRequested event,
    Emitter<WaterState> emit,
  ) async {}
}
