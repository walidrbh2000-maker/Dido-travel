import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:voyageur/core/localization/app_localizations.dart';
import 'package:voyageur/core/localization/locale_provider.dart';
import 'package:voyageur/core/router/app_router.dart';
import 'package:voyageur/core/theme/app_theme.dart';

class VoyageurApp extends ConsumerWidget {
  const VoyageurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Voyageur',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: AppLocalizations.localeResolution,
      routerConfig: router,
    );
  }
}
