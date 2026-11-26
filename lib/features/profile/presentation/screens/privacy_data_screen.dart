import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widgets.dart';

/// Privacy & Data Management screen matching Figma node 206:5750.
class PrivacyDataScreen extends StatefulWidget {
  const PrivacyDataScreen({super.key});

  @override
  State<PrivacyDataScreen> createState() => _PrivacyDataScreenState();
}

class _PrivacyDataScreenState extends State<PrivacyDataScreen> {
  static const double _headerHeight = 198;

  bool _showDeleteConfirm = false;
  bool _acknowledgedPermanent = false;

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(context, _headerHeight);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.actionNonce != curr.actionNonce,
        listener: (context, state) {
          if (state.actionStatus == ProfileActionStatus.exportRequested) {
            AppToast.show(
              context,
              message:
                  state.message ?? 'Your data export request has been queued.',
              type: AppToastType.info,
            );
          } else if (state.actionStatus == ProfileActionStatus.accountDeleted) {
            AppToast.show(
              context,
              message:
                  state.message ??
                  'Your account and local diary data were deleted.',
              type: AppToastType.success,
            );
            context.read<AuthSessionBloc>().add(const SignOutRequested());
            context.go('/welcome');
          } else if (state.actionStatus == ProfileActionStatus.failure &&
              state.message != null) {
            AppToast.show(
              context,
              message: state.message!,
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final allowPhotoAi = state.profile.privacy.allowMealPhotoProcessing;

          return AppOverlayScaffold(
            header: ProfileHeader(
              backLabel: 'Profile & Settings',
              title: 'Privacy & data\nmanagement.',
              subtitle: 'Understand your data and your options.',
              height: _headerHeight,
              onBack: () => context.pop(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 20),
                headerHeight + AppResponsive.value(context, 16),
                AppResponsive.value(context, 20),
                AppResponsive.value(context, 114),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // View your data
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View your data',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        ProfileSettingsOptionRow(
                          icon: Icons.menu_book_outlined,
                          title: 'Open food diary',
                          subtitle: 'View & review your logged food entries',
                          onTap: () => context.pushNamed('meal-details'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Privacy & AI data
                  ProfileCard(
                    backgroundColor: AppColors.softGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy & AI data',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Allow meal photo processing',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: AppResponsive.font(context, 13),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 3),
                                  ),
                                  Text(
                                    'Photo analysis needs your permission to send the selected photo to an AI service.',
                                    style: TextStyle(
                                      color: AppColors.mutedGreen,
                                      fontSize: AppResponsive.font(context, 11),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppResponsive.value(context, 12)),
                            Switch.adaptive(
                              value: allowPhotoAi,
                              activeTrackColor: AppColors.green,
                              activeThumbColor: Colors.white,
                              onChanged: (value) => context
                                  .read<ProfileBloc>()
                                  .add(ProfileMealPhotoConsentToggled(value)),
                            ),
                          ],
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        const ProfileDivider(),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Text(
                          'How photos are used',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 4)),
                        Text(
                          'AI estimates may be inaccurate. Review foods, portions and ingredients. Retention and training use must be explained by the service before consent.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        const ProfileDivider(),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Text(
                          'Review AI estimates',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 4)),
                        Text(
                          'Meal recognition can be inaccurate. Always confirm nutrition values before saving a log entry.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Manage account data
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage account data',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        ProfileSettingsOptionRow(
                          title: 'Request data export',
                          subtitle:
                              'Request a copy of your account and diary data.',
                          onTap: () => context.read<ProfileBloc>().add(
                            const ProfileDataExportRequested(),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        const ProfileDivider(),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        ProfileSettingsOptionRow(
                          title: 'Delete account & data',
                          titleColor: kProfileDeleteTextRed,
                          subtitle:
                              'Permanently removes your account and all diary history. This cannot be undone.',
                          showChevron: false,
                          onTap: () => setState(() {
                            _showDeleteConfirm = !_showDeleteConfirm;
                            if (!_showDeleteConfirm) {
                              _acknowledgedPermanent = false;
                            }
                          }),
                        ),
                        if (_showDeleteConfirm) ...[
                          SizedBox(height: AppResponsive.value(context, 12)),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              AppResponsive.value(context, 14),
                            ),
                            decoration: BoxDecoration(
                              color: kProfileDeleteSurface,
                              borderRadius: BorderRadius.circular(
                                AppResponsive.value(context, 20),
                              ),
                              border: Border.all(color: AppColors.peach),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm deletion',
                                  style: TextStyle(
                                    color: AppColors.darkGreen,
                                    fontSize: AppResponsive.font(context, 13),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: AppResponsive.value(context, 6),
                                ),
                                Text(
                                  'Your diary, goals and history would be permanently lost. Confirm only if you want to delete this account.',
                                  style: TextStyle(
                                    color: AppColors.mutedGreen,
                                    fontSize: AppResponsive.font(context, 11),
                                    height: 1.45,
                                  ),
                                ),
                                SizedBox(
                                  height: AppResponsive.value(context, 10),
                                ),
                                InkWell(
                                  onTap: () => setState(() {
                                    _acknowledgedPermanent =
                                        !_acknowledgedPermanent;
                                  }),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Checkbox(
                                          value: _acknowledgedPermanent,
                                          activeColor: kProfileDeleteTextRed,
                                          side: const BorderSide(
                                            color: AppColors.borderGreen,
                                            width: 1.5,
                                          ),
                                          onChanged: (v) => setState(() {
                                            _acknowledgedPermanent = v ?? false;
                                          }),
                                        ),
                                      ),
                                      SizedBox(
                                        width: AppResponsive.value(context, 8),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'I understand this is permanent and irreversible',
                                          style: TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: AppResponsive.font(
                                              context,
                                              11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: AppResponsive.value(context, 12),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: AppResponsive.value(
                                          context,
                                          40,
                                        ),
                                        child: OutlinedButton(
                                          onPressed: () => setState(() {
                                            _showDeleteConfirm = false;
                                            _acknowledgedPermanent = false;
                                          }),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                AppColors.darkGreen,
                                            side: const BorderSide(
                                              color: AppColors.borderGreen,
                                            ),
                                            shape: const StadiumBorder(),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: AppResponsive.font(
                                                context,
                                                13,
                                              ),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppResponsive.value(context, 8),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: AppResponsive.value(
                                          context,
                                          40,
                                        ),
                                        child: FilledButton(
                                          onPressed: state.isSaving
                                              ? null
                                              : () {
                                                  if (!_acknowledgedPermanent) {
                                                    AppToast.show(
                                                      context,
                                                      message:
                                                          'Please confirm you understand this action is permanent.',
                                                      type:
                                                          AppToastType.warning,
                                                    );
                                                    return;
                                                  }
                                                  context.read<ProfileBloc>().add(
                                                    const ProfileAccountDeletionRequested(),
                                                  );
                                                },
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                kProfileDeleteSurface,
                                            foregroundColor:
                                                kProfileDeleteTextRed,
                                            side: const BorderSide(
                                              color: AppColors.peach,
                                            ),
                                            shape: const StadiumBorder(),
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontSize: AppResponsive.font(
                                                context,
                                                13,
                                              ),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            foregrounds: const [ProfileBottomNav()],
          );
        },
      ),
    );
  }
}
