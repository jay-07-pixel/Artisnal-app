/// Supabase project credentials.
///
/// Pass at run/build time — never commit real keys:
///
/// ```bash
/// flutter run \
///   --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=your-anon-key
/// ```
abstract final class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static const photosBucket = 'photos';
  static const tutorialVideosBucket = 'tutorial-videos';
  static const tutorialImagesBucket = 'tutorial-images';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
