import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/constants/app_environment.dart';
import 'package:learning_app/core/helpers/general_helper.dart';
import 'package:learning_app/main_module.dart';
import 'package:learning_app/main_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GeneralHelper.init();
  await dotenv.load(fileName: AppEnvironment.envFileName);
  final sharedPreferences = await SharedPreferences.getInstance();
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  runApp(
    ModularApp(
      module: MainModule(sharedPreferences: sharedPreferences),
      child: const MainWidget(),
    ),
  );
}
