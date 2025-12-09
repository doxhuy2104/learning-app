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
    return Scaffold(appBar: AppBar(),body: Container());
  }
}
