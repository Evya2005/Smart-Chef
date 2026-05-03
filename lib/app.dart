import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class SmartChefApp extends ConsumerWidget {
  const SmartChefApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'שף חכם',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // Hebrew locale + RTL
      locale: const Locale('he', 'IL'),
      supportedLocales: const [Locale('he', 'IL')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Edge-to-edge: the app draws behind the system nav bar, but we must
      // prevent content from being hidden underneath it.
      // SafeArea(top:false) leaves the status bar to each Scaffold's AppBar;
      // bottom:true consumes viewPadding.bottom so every route's Scaffold body
      // is automatically constrained above the navigation bar.
      builder: (context, child) => SafeArea(
        top: false,
        child: child!,
      ),
    );
  }
}
