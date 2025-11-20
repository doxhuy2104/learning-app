import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_icons.dart';
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

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) {
          final user = state.user;
          final email = state.email ?? user?.email;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Avatar
                    CircleAvatar(
                      radius: 60,
                      foregroundImage: CachedNetworkImageProvider(
                        user?.avatar ?? '',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Username
                    Text(
                      user?.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email
                    if (email != null && email.isNotEmpty)
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.contentText,
                        ),
                      ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 32),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPress: () {
                          _showLogoutDialog(context, authBloc);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SvgPicture.asset(icon, color: AppColors.primary, width: 20, height: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.contentText),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthBloc authBloc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.bg700,
          title: const Text(
            'Đăng xuất',
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            style: TextStyle(color: AppColors.primaryText),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyle(color: AppColors.contentText),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                authBloc.add(SignOutRequest());
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
