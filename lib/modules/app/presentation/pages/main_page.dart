import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/app_annotated_region.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/modules/app/app_module.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:preload_page_view/preload_page_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PreloadPageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PreloadPageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  List<Widget> _pageViews() {
    return [];
  }

  void navigatePageView(int value) {
    _pageController.jumpToPage(value);
  }

  @override
  String get routePath => '${AppRoutes.moduleApp}${AppModuleRoutes.main}';

  @override
  onFocus() {
    final args = Modular.args;
    if (args.data != null) {
      int? index = args.data['tabIndex'] is int
          ? args.data['tabIndex']
          : int.tryParse(args.data['tabIndex'] ?? '');

      if (index != null) {
        navigatePageView(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegion(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PreloadPageView(
          pageSnapping: true,
          controller: _pageController,
          preloadPagesCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: _pageViews(),
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });

            String route = '';
            switch (value) {
              case 0:
                route = 'Explore';
                break;
              case 1:
                route = 'Feed';
                break;
              case 2:
                route = 'AiTools';
                break;
              case 3:
                route = 'AiStylists';
                break;
              case 4:
                route = 'Account';
                break;
            }
          },
        ),
        extendBody: true,
      ),
    );
  }
}
