abstract class WaterEvent {
  const WaterEvent();
}

class WaterTrackerStarted extends WaterEvent {
  const WaterTrackerStarted();
}

class WaterAdded extends WaterEvent {
  const WaterAdded(this.amountMl);

  final int amountMl;
}

class QuickAddPresetSelected extends WaterEvent {
  const QuickAddPresetSelected(this.amountMl);

  final int amountMl;
}

class WaterResetRequested extends WaterEvent {
  const WaterResetRequested();
}
