import 'package:flutter/material.dart';
import 'package:learning_app/l10n/app_localizations.dart';

extension LocalizedExtension on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
