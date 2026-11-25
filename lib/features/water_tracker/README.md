# Water tracker feature

Owns daily water intake tracking, quick-add presets, custom water entry,
daily goal progress, and synchronization with the Home screen. It coordinates
water data through repository contracts; it does not access local storage
directly from screens or presentation widgets.

Implemented architecture slices:

1. Define the `WaterIntake` domain entity and progress calculations.
2. Define the `WaterRepository` contract and business use cases.
3. Implement local persistence and daily reset in `WaterLocalDataSource`.
4. Map models and implement `WaterRepositoryImpl` in the data layer.
5. Use `WaterBloc` for state management and synchronization with the Home screen.

Persist daily totals alongside formatted date keys. Reset consumed amounts
automatically when a new day is detected while preserving the target goal.
