import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:learning_app/core/components/app_annotated_region.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
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
import 'package:learning_app/modules/auth/general/auth_module_routes.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    return AppAnnotatedRegion(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text(context.localization.signIn, style: Styles.h3.smb),
        // ),
        body: Stack(
          children: [
            Positioned(
              top: AppDimensions.insetTop(context),
              left: 8,
              child: Row(
                children: [
                  Button(
                    borderRadius: BorderRadius.circular(44),
                    onPress: () {
                      NavigationHelper.goBack();
                    },
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: SvgPicture.asset(
                        width: 10,
                        AppIcons.icArrowLeft,
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ).paddingAll(8),
                    ),
                  ),
                  Text(context.localization.signUp, style: Styles.h3.smb),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.localization.email, style: Styles.large.regular),
                  4.verticalSpace,
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

                  16.verticalSpace,
                  Text(
                    context.localization.password,
                    style: Styles.large.regular,
                  ),
                  4.verticalSpace,

                  TextInput(
                    errorMessage: context.localization.passwordMustLeast8Char,
                    controller: _passwordController,
                    placeholder: context.localization.enterPassword,
                    icon: SvgPicture.asset(
                      AppIcons.icLock,
                      colorFilter: ColorFilter.mode(
                        AppColors.secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                    validator: AppValidator.validatePassword,
                  ),

                  16.verticalSpace,
                  Text(
                    context.localization.password,
                    style: Styles.large.regular,
                  ),
                  4.verticalSpace,

                  TextInput(
                    errorMessage: context.localization.passwordMustLeast8Char,
                    controller: _passwordController,
                    placeholder: context.localization.enterPassword,
                    icon: SvgPicture.asset(
                      AppIcons.icLock,
                      colorFilter: ColorFilter.mode(
                        AppColors.secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                    validator: AppValidator.validatePassword,
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
                      text: context.localization.signUp,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AppDimensions.insetBottom(context) + 16,
              left: 0,
              right: 0,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '${context.localization.haveAccount} ',
                  style: Styles.normal.regular,
                  children: [
                    TextSpan(
                      text: context.localization.signIn,
                      style: Styles.normal.regular.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationHelper.goBack();
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
