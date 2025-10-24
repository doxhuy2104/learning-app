import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_icons.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/constants/app_validator.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_bloc.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  @override
  void dispose() {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text(con, style: Styles.h3.smb)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.localization.email, style: Styles.large.regular),
            TextInput(
              errorMessage: context.localization.invalidEmail,
              controller: _emailController,
              placeholder: context.localization.enterEmail,
              icon: SvgPicture.asset(
                AppIcons.icEmail,
                colorFilter: ColorFilter.mode(
                  AppColors.secondaryText,
                  BlendMode.srcIn,
                ),
              ),
              validator: AppValidator.validateEmail,
            ),
            20.verticalSpace,

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPress: () async {
                  final username = _usernameController.text;
                  if (username.isNotEmpty) {}
                  await Future.delayed(Duration(milliseconds: 500));
                  // NavigationHelper.replace(
                  //   '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
                  // );
                },
                text: context.localization.sendEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
