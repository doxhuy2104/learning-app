import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/group_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/account/data/repositories/account_repository.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_bloc.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_event.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_state.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_state.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _repository = Modular.get<AccountRepository>();
  List<GroupModel> _groups = [];
  List<GroupModel> _filteredGroups = [];
  List<String> _block = [];
  String? _selectedBlock;
  int? _selectedGroup;
  final _accountBloc = Modular.get<AccountBloc>();
  final _authBloc = Modular.get<AuthBloc>();

  String _getBlockPrefix(String blockLabel) {
    if (blockLabel.contains('A')) return 'A';
    if (blockLabel.contains('B')) return 'B';
    if (blockLabel.contains('C')) return 'C';
    if (blockLabel.contains('D')) return 'D';
    return '';
  }

  void _filterGroupsByBlock(String? blockLabel) {
    if (blockLabel == null || blockLabel.isEmpty) {
      setState(() {
        _selectedBlock = null;
        _selectedGroup = null;
        _filteredGroups = [];
      });
      return;
    }

    final prefix = _getBlockPrefix(blockLabel);
    setState(() {
      _selectedBlock = blockLabel;
      _selectedGroup = null;
      _filteredGroups = _groups
          .where((g) => (g.name ?? '').startsWith(prefix))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    final user = _accountBloc.state.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _loadGroups();
  }

  void _loadGroups() async {
    final rt = await _repository.getGroups();
    rt.fold(
      (l) {
        Utils.debugLogError(l.reason);
      },
      (r) {
        final userGroup = _accountBloc.state.user?.group;
        String? initialBlock;
        int? initialGroupId;
        List<GroupModel> initialFiltered = [];

        if (userGroup != null) {
          final matched = r.firstWhere(
            (g) => g.id == userGroup.id,
            orElse: () => userGroup,
          );

          initialGroupId = matched.id;

          final name = (matched.name ?? '').toUpperCase();

          if (name.startsWith('A')) initialBlock = 'Khối A';
          if (name.startsWith('B')) initialBlock = 'Khối B';
          if (name.startsWith('C')) initialBlock = 'Khối C';
          if (name.startsWith('D')) initialBlock = 'Khối D';

          if (initialBlock != null) {
            final prefix = _getBlockPrefix(initialBlock);
            initialFiltered = r
                .where((g) => (g.name ?? '').toUpperCase().startsWith(prefix))
                .toList();
          }
        }

        setState(() {
          _block = ['Khối A', 'Khối B', 'Khối C', 'Khối D'];
          _groups = r;
          _selectedBlock = initialBlock;
          _selectedGroup = initialGroupId;
          _filteredGroups = initialFiltered;
        });
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.localization.accountInfo)),
      body: BlocBuilder<AccountBloc, AccountState>(
        bloc: _accountBloc,
        builder: (context, state) {
          final email = state.user?.email ?? '';

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.fullName,
                  style: Styles.large.regular,
                ),
                const SizedBox(height: 8),
                TextInput(controller: _nameController),
                const SizedBox(height: 16),
                Text(context.localization.email, style: Styles.large.regular),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderColor, width: 1),
                    color: AppColors.borderColor,
                  ),
                  child: Text(
                    email,
                    style: Styles.medium.regular.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
                16.verticalSpace,
                Text(
                  context.localization.groupSelection,
                  style: Styles.large.regular,
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  isExpanded: true,

                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  value: _selectedBlock,
                  hint: const Text('Chọn khối'),
                  items: _block
                      .map(
                        (b) =>
                            DropdownMenuItem<String>(value: b, child: Text(b)),
                      )
                      .toList(),
                  onChanged: (value) {
                    _filterGroupsByBlock(value);
                  },
                ),
                12.verticalSpace,
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  focusColor: AppColors.primary,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  value: _selectedGroup,
                  hint: const Text('Chọn tổ hợp'),
                  items: _filteredGroups
                      .map(
                        (g) => DropdownMenuItem<int>(
                          value: g.id,
                          child: Text(
                            '${g.name ?? ''} - ${(g.subjects ?? []).map((s) => s.title!.contains('Giáo') ? 'GDKTPL' : s.title).whereType<String>().join(', ')}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGroup = value;
                    });
                  },
                ),

                Expanded(child: SizedBox()),
                PrimaryButton(
                  onPress: () async {
                    AppIndicator.show();
                    final rt = await _repository.updateAccount(
                      name: _nameController.text,
                      groupId: _selectedGroup,
                    );
                    rt.fold(
                      (l) {
                        AppIndicator.hide();

                        Utils.debugLogError(l.reason);
                      },
                      (r) {
                        AppIndicator.hide();
                        _accountBloc.add(UpdateAccountInfo(r));
                        NavigationHelper.goBack();
                      },
                    );
                  },
                  text: context.localization.save,
                ),
              ],
            ),
          ).paddingAll(16);
        },
      ),
    );
  }
}
