import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../providers/social_connection_provider.dart';

class SocialAccountsScreen extends ConsumerStatefulWidget {
  const SocialAccountsScreen({super.key});

  @override
  ConsumerState<SocialAccountsScreen> createState() =>
      _SocialAccountsScreenState();
}

class _SocialAccountsScreenState extends ConsumerState<SocialAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(socialConnectionProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(socialConnectionProvider.notifier).clearError();
      }
    });

    final status = ref.watch(socialConnectionProvider);
    final notifier = ref.read(socialConnectionProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('חיבורים לרשתות חברתיות')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Explanation card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'איך זה עובד?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  const Text(
                    'לחיצה על "התחבר עם פייסבוק" תפתח חלון התחברות רשמי של Meta. '
                    'האפליקציה מבקשת רק גישה לפרופיל הציבורי שלך (שם) — '
                    'הסיסמה שלך לעולם לא מועברת לאפליקציה.',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),

          // Combined Facebook + Instagram tile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.facebook, size: 32, color: Color(0xFF1877F2)),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'פייסבוק ואינסטגרם',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (status.isConnected)
                            Text(
                              'מחובר כ: ${status.facebookUserName ?? ''}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            const Text(
                              'לא מחובר',
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(16),
                  if (status.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (status.isConnected)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                      onPressed: () => _confirmDisconnect(context, notifier),
                      child: const Text('נתק'),
                    )
                  else
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('התחבר עם פייסבוק'),
                      onPressed: notifier.loginFacebook,
                    ),
                ],
              ),
            ),
          ),
          const Gap(16),

          // Instagram note card
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const Gap(8),
                  const Expanded(
                    child: Text(
                      'לייבוא פוסטים מאינסטגרם, הפרופיל שלך צריך להיות מקושר לחשבון פייסבוק.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDisconnect(
    BuildContext context,
    SocialConnectionNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('נתק מפייסבוק?'),
        content: const Text(
          'תצטרך להתחבר מחדש כדי לייבא פוסטים מפייסבוק ואינסטגרם.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('ביטול'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('נתק'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.disconnect();
    }
  }
}
