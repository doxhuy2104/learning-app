import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/core/constants/app_keys.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_theme.dart';
import 'package:learning_app/core/helpers/general_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/l10n/app_localizations.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_bloc.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_state.dart';
import 'package:learning_app/modules/auth/general/auth_module_routes.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with WidgetsBindingObserver {
  bool _firstLoad = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    /* always open splash first */
    Modular.setInitialRoute(
      '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
    );
    Modular.setNavigatorKey(AppKeys.navigatorKey);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1)),
      child: MaterialApp.router(
        title: GeneralHelper.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        // locale: appLanguage.locale,
        scaffoldMessengerKey: AppKeys.scaffoldMessengerKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: Modular.routerConfig,
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;

          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }

          return supportedLocales.first; // fallback to en
        },
        localeListResolutionCallback: (locales, supportedLocales) {
          if (locales == null || locales.isEmpty) {
            return supportedLocales.first;
          }

          for (final locale in locales) {
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale.languageCode) {
                return supported;
              }
            }
          }

          return supportedLocales.first; // fallback to en
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils.debugLog('AppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      // get common data
      // Modular.get<AppBloc>().add(AppConfigRequested());
    }
    super.didChangeAppLifecycleState(state);
  }
}
