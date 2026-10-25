# Core storage

Put generic local-storage contracts and cache policies here.

Storage implementations should be injected through repositories. A screen,
widget, Bloc, or domain entity must not read SharedPreferences, a database, or
secure storage directly.
