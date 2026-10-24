import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';

enum AppToastType { success, error, warning, info }

/// Displays the app's standard notification above the current screen content.
///
/// A single toast is kept visible at a time so fast consecutive actions do not
/// create a stack of competing messages. The root overlay keeps the toast
/// above headers, cards, dialogs hosted by the current route, and scrollable
/// content.
abstract final class AppToast {
  static OverlayEntry? _activeEntry;

  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null || message.trim().isEmpty) return;

    _activeEntry?.remove();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppToastOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          if (identical(_activeEntry, entry)) {
            _activeEntry = null;
            entry.remove();
          }
        },
      ),
    );

    _activeEntry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _activeEntry?.remove();
    _activeEntry = null;
  }
}

class _AppToastOverlay extends StatefulWidget {
  const _AppToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final visual = _ToastVisual.fromType(widget.type);

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 14),
                AppResponsive.value(context, 10),
                AppResponsive.value(context, 14),
                0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _controller,
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: _dismiss,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.value(context, 13),
                            vertical: AppResponsive.value(context, 11),
                          ),
                          decoration: BoxDecoration(
                            color: visual.background,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: visual.accent.withValues(alpha: .28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkGreen.withValues(
                                  alpha: .16,
                                ),
                                blurRadius: 22,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: visual.accent.withValues(alpha: .14),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  visual.icon,
                                  color: visual.accent,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: AppResponsive.value(context, 10)),
                              Expanded(
                                child: Text(
                                  widget.message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: visual.text,
                                    fontSize: AppResponsive.font(context, 12),
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppResponsive.value(context, 8)),
                              Icon(
                                Icons.close_rounded,
                                color: visual.text.withValues(alpha: .55),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastVisual {
  const _ToastVisual({
    required this.background,
    required this.accent,
    required this.text,
    required this.icon,
  });

  final Color background;
  final Color accent;
  final Color text;
  final IconData icon;

  factory _ToastVisual.fromType(AppToastType type) {
    return switch (type) {
      AppToastType.success => const _ToastVisual(
        background: AppColors.softGreen,
        accent: AppColors.green,
        text: AppColors.darkGreen,
        icon: Icons.check_circle_rounded,
      ),
      AppToastType.error => const _ToastVisual(
        background: Color(0xFFFFE8E3),
        accent: Color(0xFFC64F45),
        text: Color(0xFF6F2925),
        icon: Icons.error_rounded,
      ),
      AppToastType.warning => const _ToastVisual(
        background: AppColors.yellow,
        accent: Color(0xFF9C7B21),
        text: AppColors.darkGreen,
        icon: Icons.warning_rounded,
      ),
      AppToastType.info => const _ToastVisual(
        background: AppColors.cream,
        accent: AppColors.green,
        text: AppColors.darkGreen,
        icon: Icons.info_rounded,
      ),
    };
  }
}
