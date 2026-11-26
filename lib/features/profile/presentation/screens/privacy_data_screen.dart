import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/privacy_data_bloc.dart';
import '../widgets/privacy_data_widgets.dart';

class PrivacyDataScreen extends StatefulWidget {
  const PrivacyDataScreen({super.key});

  @override
  State<PrivacyDataScreen> createState() => _PrivacyDataScreenState();
}

class _PrivacyDataScreenState extends State<PrivacyDataScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrivacyDataBloc>().add(const PrivacyDataStarted());
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('profile');
    }
  }

  void _openFoodDiary(BuildContext context) {
    // Food diary screen/route is not implemented yet in lib/features/meals/.
    AppToast.show(
      context,
      message: 'Food diary will be connected soon.',
      type: AppToastType.info,
      duration: const Duration(milliseconds: 2200),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.read<HomeBloc>().add(const HomeTabSelected(0));
      context.goNamed('home');
      return;
    }
    if (index == 4) {
      _navigateBack(context);
      return;
    }
    AppToast.show(
      context,
      message: '${appNavigationItems[index].label} will be connected soon.',
      type: AppToastType.info,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(
      context,
      PrivacyDataHeader.baseHeight,
    );
    final overlap = AppResponsive.value(
      context,
      PrivacyDataHeader.overlapDepth,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<PrivacyDataBloc, PrivacyDataState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage &&
                current.feedbackMessage != null ||
            previous.deletionStatus != current.deletionStatus &&
                current.deletionStatus == AccountDeletionStatus.succeeded,
        listener: (context, state) {
          final message = state.feedbackMessage;
          if (message != null && message.isNotEmpty) {
            final type = switch (state.feedbackType) {
              PrivacyFeedbackType.success => AppToastType.success,
              PrivacyFeedbackType.warning => AppToastType.warning,
              PrivacyFeedbackType.error => AppToastType.error,
              _ => AppToastType.info,
            };
            AppToast.show(context, message: message, type: type);
          }

          if (state.deletionStatus == AccountDeletionStatus.succeeded) {
            context.goNamed('sign-in');
          }
        },
        builder: (context, state) {
          if (state.status == PrivacyDataStatus.loading ||
              state.status == PrivacyDataStatus.initial) {
            return AppOverlayScaffold(
              header: PrivacyDataHeader(onBack: () => _navigateBack(context)),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              ),
            );
          }

          return AppOverlayScaffold(
            header: PrivacyDataHeader(onBack: () => _navigateBack(context)),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: headerHeight - overlap),
                          child: Stack(
                            children: [
                              Container(
                                height: overlap * 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                    bottomRight: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppResponsive.value(context, 20),
                                  overlap,
                                  AppResponsive.value(context, 20),
                                  0,
                                ),
                                child: ViewYourDataCard(
                                  onOpenFoodDiary: () =>
                                      _openFoodDiary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 16),
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 96),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            PrivacyAndAiDataCard(
                              allowMealPhotoProcessing:
                                  state.allowMealPhotoProcessing,
                              onTogglePhotoProcessing: (enabled) => context
                                  .read<PrivacyDataBloc>()
                                  .add(MealPhotoProcessingToggled(enabled)),
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            ManageAccountDataCard(
                              isExporting:
                                  state.exportStatus ==
                                  DataExportStatus.requesting,
                              isDeletionConfirmed: state.isDeletionConfirmed,
                              isDeleting:
                                  state.deletionStatus ==
                                  AccountDeletionStatus.deleting,
                              onRequestDataExport: () => context
                                  .read<PrivacyDataBloc>()
                                  .add(const DataExportRequested()),
                              onDeletionConfirmationChanged: (confirmed) =>
                                  context.read<PrivacyDataBloc>().add(
                                    DeletionConfirmationToggled(confirmed),
                                  ),
                              onCancelDeletion: () => context
                                  .read<PrivacyDataBloc>()
                                  .add(const DeletionCancelled()),
                              onConfirmDeleteAccount: () => context
                                  .read<PrivacyDataBloc>()
                                  .add(const AccountDeletionRequested()),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: AppResponsive.value(context, 14),
                  right: AppResponsive.value(context, 14),
                  bottom: AppResponsive.value(context, 8),
                  child: AppBottomNavBar(
                    selectedIndex: 4,
                    onSelected: (index) => _handleBottomNavTap(context, index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
