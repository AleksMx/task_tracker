import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/services/LocalizationService.dart';

import 'MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: LocalizationService().getSupportedLocales(),
      path: 'i18n',
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      fallbackLocale: const Locale('en'),
      child: const MyApp()
    )
  );
}