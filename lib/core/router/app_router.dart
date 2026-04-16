import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../services/share_intent_service.dart';
import 'main_shell.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/discovery/views/discovery_basket_screen.dart';
import '../../features/ingestion/views/ingestion_screen.dart';
import '../../features/planner/views/planner_home_screen.dart';
import '../../features/planner/views/session_setup_screen.dart';
import '../../features/planner/views/mission_control_screen.dart';
import '../../features/recipes/views/cook_mode_screen.dart';
import '../../features/recipes/views/recipe_detail_screen.dart';
import '../../features/recipes/views/recipe_edit_screen.dart';
import '../../features/recipes/views/recipe_list_screen.dart';
import '../../features/recipes/views/recipe_versions_screen.dart';
import '../../features/ingestion/views/social_accounts_screen.dart';
import '../../features/settings/views/category_management_screen.dart';
import '../../features/settings/views/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authValue = ref.watch(authStateProvider);
  final sharePayload = ref.watch(shareIntentProvider);

  return GoRouter(
    initialLocation: '/recipes',
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authValue.value != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/recipes';

      if (sharePayload != null &&
          isLoggedIn &&
          state.matchedLocation != '/ingest') {
        return '/ingest';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).authStateChanges,
    ),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/recipes',
            builder: (context, state) => const RecipeListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    RecipeDetailScreen(recipeId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => RecipeEditScreen(
                        recipeId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'cook',
                    builder: (context, state) => CookModeScreen(
                        recipeId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'versions',
                    builder: (context, state) => RecipeVersionsScreen(
                        recipeId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const PlannerHomeScreen(),
            routes: [
              GoRoute(
                path: 'setup',
                builder: (context, state) => const SessionSetupScreen(),
              ),
              GoRoute(
                path: 'session/:id',
                builder: (context, state) => MissionControlScreen(
                    sessionId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/ingest',
        builder: (context, state) => const IngestionScreen(),
      ),
      GoRoute(
        path: '/discover',
        builder: (_, __) => const DiscoveryBasketScreen(),
      ),
      GoRoute(
        path: '/social-accounts',
        builder: (context, state) => const SocialAccountsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/categories',
        builder: (_, __) => const CategoryManagementScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}

/// Bridges a [Stream] to a [Listenable] so GoRouter can refresh on auth changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
