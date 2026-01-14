import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/app_annotated_region.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_icons.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/modules/account/presentation/pages/account_page.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/app/presentation/components/title_navigation_bar/navigation_bar.dart';
import 'package:learning_app/modules/app/presentation/components/title_navigation_bar/navigation_bar_item.dart';
import 'package:learning_app/modules/exam/presentation/pages/exam_page.dart';
import 'package:learning_app/modules/practice/presentation/pages/practice_page.dart';
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
    return [PracticePage(), ExamPage(), AccountPage()];
  }

  void navigatePageView(int value) {
    _pageController.jumpToPage(value);
  }

  String get routePath => '${AppRoutes.moduleApp}${AppModuleRoutes.main}';

  void onFocus() {
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
          // physics: const NeverScrollableScrollPhysics(),
          children: _pageViews(),
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        extendBody: true,
        bottomNavigationBar: TitledBottomNavigationBar(
          onTap: (value) {
            navigatePageView(value);
          },
          inactiveColor: Colors.white,
          activeColor: AppColors.primary,
          indicatorColor: Colors.transparent,
          currentIndex: _currentIndex,
          items: [
            // TitledNavigationBarItem(
            //   iconPath: AppIcons.icHomeInactive,
            //   activeIconPath: AppIcons.icHomeActive,
            //   title: context.localization.home,
            // ),
            TitledNavigationBarItem(
              iconPath: AppIcons.icBook,
              activeIconPath: AppIcons.icBookActive,
              title: context.localization.practice,
            ),
            TitledNavigationBarItem(
              iconPath: AppIcons.icText,
              activeIconPath: AppIcons.icText,
              title: context.localization.exam,
            ),
            TitledNavigationBarItem(
              iconPath: AppIcons.icAccountInactive,
              activeIconPath: AppIcons.icAccountActive,
              title: context.localization.account,
            ),
          ],
        ),
      ),
    );
  }
}
