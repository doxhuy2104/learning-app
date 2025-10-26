import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_icons.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/modules/auth/general/auth_module_routes.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Button(
          onPress: () {
           NavigationHelper.reset(
            '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
          );
          },
          child: SvgPicture.asset(AppIcons.icLogout, color: Colors.black),
        ),
      ),
    );
  }
}
