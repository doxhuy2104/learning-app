import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:learning_app/core/components/app_annotated_region.dart';
import 'package:learning_app/core/components/app_dialog.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_icons.dart';
import 'package:learning_app/core/constants/app_images.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/constants/app_validator.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/auth_helper.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
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
  final _confirmPasswordController = TextEditingController();
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
            Image.asset(AppImages.imgLogo),

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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.email,
                      style: Styles.large.regular,
                    ),
                    4.verticalSpace,
                    TextInput(
                      formKey: _formKey,
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
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      nextFocusNode: _passwordFocusNode,
                    ),

                    16.verticalSpace,
                    Text(
                      context.localization.password,
                      style: Styles.large.regular,
                    ),
                    4.verticalSpace,

                    TextInput(
                      formKey: _formKey,
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
                      isSecure: true,
                      focusNode: _passwordFocusNode,
                      nextFocusNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.next,
                    ),

                    16.verticalSpace,
                    Text(
                      context.localization.confirmPassword,
                      style: Styles.large.regular,
                    ),
                    4.verticalSpace,

                    TextInput(
                      formKey: _formKey,
                      errorMessage: context.localization.confirmPasswordError,
                      controller: _confirmPasswordController,
                      placeholder: context.localization.enterConfirmPassword,
                      icon: SvgPicture.asset(
                        AppIcons.icLock,
                        colorFilter: ColorFilter.mode(
                          AppColors.secondaryText,
                          BlendMode.srcIn,
                        ),
                      ),
                      validator: (value) => _passwordController.text == value,
                      isSecure: true,
                      focusNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.done,
                    ),

                    20.verticalSpace,

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPress: () async {
                          final process = _formKey.currentState?.validate();

                          if (process!) {
                            AppIndicator.show();

                            try {
                              final rt = await AuthHelper.registerWithPassword(
                                emailAddress: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (rt?.user != null) {
                                Utils.debugLog(
                                  'Register success rt:${rt?.user?.email}',
                                );

                                if (mounted) {
                                  AppDialog.show(
                                    dismissible: false,
                                    title:
                                        context.localization.register_success,
                                    // message: '',
                                    type: AppDialogType.success,
                                    confirmText: context.localization.signIn,
                                    onConfirm: () {
                                      NavigationHelper.replace(
                                        '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
                                      );
                                    },
                                  );
                                }
                              }
                            } on FirebaseAuthException catch (e) {
                              Utils.debugLogError(e.code);

                              switch (e.code) {
                                case 'email-already-in-use':
                                  AppDialog.show(
                                    title: context.localization.emailInUse,
                                    // message: '',
                                    type: AppDialogType.failed,
                                  );
                                  break;
                                // case 'weak-password':
                                //   AppDialog.show(
                                //     title: '',
                                //     message: '',
                                //     type: AppDialogType.failed,
                                //     confirmText: '',
                                //   );
                                //   break;
                                default:
                                  AppDialog.show(
                                    title: context.localization.errorTitle,
                                    message: e.code,
                                    type: AppDialogType.failed,
                                  );
                                  break;
                              }
                            } catch (e) {
                              Utils.debugLogError(e);
                              AppDialog.show(
                                title: context.localization.errorTitle,
                                message: e.toString(),
                                type: AppDialogType.failed,
                              );
                            } finally {
                              AppIndicator.hide();
                            }
                          }
                        },
                        text: context.localization.signUp,
                      ),
                    ),
                  ],
                ),
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
