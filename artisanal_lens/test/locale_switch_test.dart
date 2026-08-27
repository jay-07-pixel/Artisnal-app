import 'package:artisanal_lens/features/checklist/presentation/material_selection_page.dart';
import 'package:artisanal_lens/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_l10n.dart';

void main() {
  testWidgets('Hindi settings copy replaces English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(
          locale: const Locale('hi'),
          home: const Scaffold(body: SettingsPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('सेटिंग्स'), findsOneWidget);
    expect(find.text('भाषा'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
    expect(find.text('Language'), findsNothing);
  });

  testWidgets('Assamese settings copy replaces English', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(
          locale: const Locale('as'),
          home: const Scaffold(body: SettingsPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ছেটিংছ'), findsOneWidget);
    expect(find.text('ভাষা'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('Assamese material page is translated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(
          locale: const Locale('as'),
          home: const MaterialSelectionPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('আপুনি কোনবিধ কাপোৰৰ\nসৈতে কাম কৰি আছে?'), findsOneWidget);
    expect(find.text('পাট'), findsOneWidget);
    expect(find.text('আগবাঢ়ক'), findsOneWidget);
    expect(find.text('Silk'), findsNothing);
    expect(find.text('Continue'), findsNothing);
  });

  testWidgets('Hindi material page is translated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: l10nApp(
          locale: const Locale('hi'),
          home: const MaterialSelectionPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('आप किस कपड़े के साथ\nकाम कर रहे हैं?'), findsOneWidget);
    expect(find.text('रेशम'), findsOneWidget);
    expect(find.text('आगे बढ़ें'), findsOneWidget);
    expect(find.text('What material are\nyou working with?'), findsNothing);
  });
}
