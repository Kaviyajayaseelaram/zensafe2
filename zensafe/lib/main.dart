import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/core/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');

  final supabaseUrl = Env.supabaseUrl;
  final supabaseKey = Env.supabaseAnonKey;

  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  } else {
    debugPrint('Supabase env is missing. App will run in mock/offline mode.');
  }

  runApp(const ProviderScope(child: ZenSafeApp()));
}
