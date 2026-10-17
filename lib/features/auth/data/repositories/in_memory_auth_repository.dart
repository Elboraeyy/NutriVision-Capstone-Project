import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Temporary repository with local session persistence until a remote backend
/// is connected.
class InMemoryAuthRepository implements AuthRepository {
  static const _seenWelcomeKey = 'auth.seen_welcome';
  static const _signedInKey = 'auth.signed_in';
  static const _userIdKey = 'auth.user_id';
  static const _userNameKey = 'auth.user_name';
  static const _userEmailKey = 'auth.user_email';
  static const _registeredNameKey = 'auth.registered_name';
  static const _registeredEmailKey = 'auth.registered_email';

  AuthUser? _currentUser;
  SharedPreferences? _preferences;
  bool _hasSeenWelcome = false;
  bool _initialized = false;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  bool get hasSeenWelcome => _hasSeenWelcome;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    _preferences = await _loadPreferences();
    if (_preferences != null) {
      _hasSeenWelcome = _preferences!.getBool(_seenWelcomeKey) ?? false;
      final isSignedIn = _preferences!.getBool(_signedInKey) ?? false;
      final id = _preferences!.getString(_userIdKey);
      final name = _preferences!.getString(_userNameKey);
      final email = _preferences!.getString(_userEmailKey);

      if (isSignedIn && id != null && name != null && email != null) {
        _currentUser = AuthUser(id: id, name: name, email: email);
      }
    }

    _initialized = true;
  }

  @override
  Future<void> markWelcomeSeen() async {
    _hasSeenWelcome = true;
    final preferences = _preferences ??= await _loadPreferences();
    await preferences?.setBool(_seenWelcomeKey, true);
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _currentUser = AuthUser(
      id: email.toLowerCase(),
      name: name,
      email: email.toLowerCase(),
    );
    await _persistCurrentUser();
    final preferences = _preferences ??= await _loadPreferences();
    await preferences?.setString(_registeredNameKey, name);
    await preferences?.setString(_registeredEmailKey, email.toLowerCase());
    return _currentUser!;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.toLowerCase();
    final preferences = _preferences ??= await _loadPreferences();
    final registeredEmail = preferences?.getString(_registeredEmailKey);
    final registeredName = preferences?.getString(_registeredNameKey);
    final name =
        registeredEmail == normalizedEmail &&
            registeredName != null &&
            registeredName.trim().isNotEmpty
        ? registeredName.trim()
        : 'Mohamed';

    _currentUser = AuthUser(
      id: normalizedEmail,
      name: name,
      email: normalizedEmail,
    );
    await _persistCurrentUser();
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    final preferences = _preferences ??= await _loadPreferences();
    await preferences?.setBool(_signedInKey, false);
    await preferences?.remove(_userIdKey);
    await preferences?.remove(_userNameKey);
    await preferences?.remove(_userEmailKey);
  }

  Future<void> _persistCurrentUser() async {
    final user = _currentUser;
    if (user == null) return;

    final preferences = _preferences ??= await _loadPreferences();
    await preferences?.setBool(_signedInKey, true);
    await preferences?.setString(_userIdKey, user.id);
    await preferences?.setString(_userNameKey, user.name);
    await preferences?.setString(_userEmailKey, user.email);
    await preferences?.setBool(_seenWelcomeKey, true);
    _hasSeenWelcome = true;
  }

  Future<SharedPreferences?> _loadPreferences() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      // Keep the repository usable in unit tests where platform plugins may
      // not be registered. The real app uses SharedPreferences normally.
      return null;
    }
  }
}
