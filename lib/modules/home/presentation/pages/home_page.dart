import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_event.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = Modular.get<HomeBloc>();
  @override
  void initState() {
    super.initState();
    if (_homeBloc.state.subjects.isEmpty) {
      _homeBloc.add(GetSubjects());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                _homeBloc.add(GetSubjects());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(),
                    const SizedBox(height: 24),
                    _buildProgressRow(),
                    const SizedBox(height: 24),
                    _buildAiSuggestionCard(),
                    const SizedBox(height: 24),
                    _buildQuickPracticeRow(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    // TODO: thay 'Huy' bằng tên user thật nếu có trong state
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chào bạn,', style: Styles.medium.secondary),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Huy', style: Styles.xxlarge.smb),
            const SizedBox(width: 8),
            const Text('👋', style: TextStyle(fontSize: 24)),
          ],
        ),
      ],
    );
  }

  Widget _buildCardContainer({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 130, 151, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildProgressRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiến độ hôm nay',
                  style: Styles.small.secondary.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '12/20 câu',
                  style: Styles.large.smb.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: 12 / 20,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tỉ lệ đúng',
                  style: Styles.small.secondary.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: index < 3
                                ? AppColors.primary.withOpacity(0.8)
                                : Colors.white10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'T2',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    Text(
                      'T3',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    Text(
                      'T4',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    Text(
                      'T5',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    Text(
                      'T6',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiSuggestionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gợi ý từ AI', style: Styles.large.smb),
        const SizedBox(height: 12),
        _buildCardContainer(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E40FF),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Câu hỏi bạn hay sai',
                      style: Styles.large.smb.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'AI đã tổng hợp các dạng bài bạn cần cải thiện: '
                '5 câu Toán hàm số mũ và 3 câu Lý điện xoay chiều.',
                style: Styles.small.secondary.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Button(
                  onPress: () {
                    // TODO: điều hướng sang màn luyện tập do AI gợi ý
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Luyện ngay',
                          style: Styles.medium.smb.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPracticeRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Làm bài nhanh', style: Styles.large.smb),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1E40FF),
                      ),
                      child: const Icon(Icons.flash_on, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text('10 câu', style: Styles.large.smb),
                    const SizedBox(height: 4),
                    Text('Luyện nhanh', style: Styles.small.secondary),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1E40FF),
                      ),
                      child: const Icon(Icons.menu_book, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '20 câu',
                      style: Styles.large.smb.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Theo môn',
                      style: Styles.small.secondary.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectItem(String title) {
    return _buildCardContainer(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: const Icon(Icons.school, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(title, style: Styles.medium.smb.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
