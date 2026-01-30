import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

/// Extension to easily access localized strings
extension L10nExtension on BuildContext {
  /// Get the AppLocalizations instance for the current context
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
