import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isTopLevel = location == '/recipes' || location == '/planner';
    final selectedIndex = location.startsWith('/planner') ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: isTopLevel
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (i) => context.go(i == 0 ? '/recipes' : '/planner'),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  label: 'מתכונים',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'תכנון',
                ),
              ],
            )
          : null,
    );
  }
}
