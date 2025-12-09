import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learning_app/core/components/app_dialog.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_icons.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/modules/account/general/account_module_routes.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_bloc.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_state.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_event.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_state.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final authBloc = Modular.get<AuthBloc>();
    final accountBloc = Modular.get<AccountBloc>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocBuilder<AccountBloc, AccountState>(
        bloc: accountBloc,
        builder: (context, accountState) {
          final user = accountState.user;
          return BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, authState) {
              final email = authState.email ?? user?.email;

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  CircleAvatar(
                    radius: 60,
                    foregroundImage: CachedNetworkImageProvider(
                      user?.avatar ?? '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (email != null && email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildSettingItem(
                                  context.localization.accountInfo,
                                  () {
                                    NavigationHelper.navigate(
                                      '${AppRoutes.moduleAccount}${AccountModuleRoutes.accountInfo}',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              onPress: () {
                                AppDialog.show(
                                  title: context.localization.confirmLogout,
                                  cancelText: context.localization.cancel,
                                  confirmText: context.localization.logout,
                                  message:
                                      context.localization.confirmLogoutMessage,
                                  dismissible: false,
                                  onConfirm: () {
                                    authBloc.add(SignOutRequest());
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.icLogout,
                                      color: Colors.white,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Đăng xuất',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: AppDimensions.paddingNavBar, top: 8),
                    ),
                  ),
                ],
              ).paddingOnly(top: AppDimensions.insetTop(context));
            },
          );
        },
      ),
    );
  }

  Widget _buildSettingItem(String text, VoidCallback onPress) {
    return SizedBox(
      height: 16,
      child: Button(
        showEffect: false,
        onPress: onPress,
        child: Row(
          children: [
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
