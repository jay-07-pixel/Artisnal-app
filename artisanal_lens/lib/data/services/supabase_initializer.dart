import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/supabase_config.dart';

/// Boots Supabase when credentials are supplied via `--dart-define`.
///
/// When [SupabaseConfig.isConfigured] is false the app stays fully offline;
/// nothing in the UI breaks.
Future<void> initializeSupabase() async {
  if (!SupabaseConfig.isConfigured) {
    debugPrint(
      'Supabase: not configured. Pass SUPABASE_URL and SUPABASE_ANON_KEY '
      'via --dart-define to enable cloud sync.',
    );
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  debugPrint('Supabase: initialized.');
}

SupabaseClient? get supabaseClient =>
    SupabaseConfig.isConfigured ? Supabase.instance.client : null;
