import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_bloc.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final _authBloc = Modular.get<AuthBloc>();
  AppBloc _appBloc = Modular.get<AppBloc>();
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Đăng nhập', style: Styles.h3.smb)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // TODO: Implement login logic
                  final username = _usernameController.text;
                  if (username.isNotEmpty) {}
                  await Future.delayed(Duration(milliseconds: 500));
                  NavigationHelper.replace(
                    '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
                  );
                },
                child: const Text('Đăng nhập'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
