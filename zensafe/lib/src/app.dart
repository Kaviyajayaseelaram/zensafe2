import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class ZenSafeApp extends ConsumerWidget {
  const ZenSafeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = buildAppTheme();

    return MaterialApp.router(
      title: 'ZenSafe',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        textTheme: GoogleFonts.interTextTheme(theme.textTheme),
      ),
      routerConfig: router,
    );
  }
}

