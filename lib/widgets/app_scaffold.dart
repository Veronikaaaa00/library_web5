import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/permissions.dart';
import '../models/role.dart';
import '../state/auth_notifier.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final auth = context.watch<AuthNotifier>();
    final destinations = _destinations(auth.role);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (auth.user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  '${auth.user!.fullName} (${auth.user!.role.label})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          IconButton(
            tooltip: 'Выйти',
            onPressed: () async {
              await context.read<AuthNotifier>().logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
          ...?actions,
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex(location, destinations),
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          context.go(destinations[index].path);
        },
        children: [
          const DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Библиотека',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          for (final d in destinations)
            NavigationDrawerDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: Text(d.label),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }

  List<_NavItem> _destinations(Role? role) {
    final items = <_NavItem>[
      const _NavItem('/', 'Главная', Icons.home_outlined, Icons.home),
      const _NavItem(
        '/books',
        'Книги',
        Icons.menu_book_outlined,
        Icons.menu_book,
      ),
      const _NavItem(
        '/authors',
        'Авторы',
        Icons.person_outline,
        Icons.person,
      ),
      const _NavItem(
        '/genres',
        'Жанры',
        Icons.category_outlined,
        Icons.category,
      ),
      const _NavItem(
        '/publishers',
        'Издательства',
        Icons.business_outlined,
        Icons.business,
      ),
      const _NavItem(
        '/loans',
        'Выдачи',
        Icons.assignment_outlined,
        Icons.assignment,
      ),
    ];
    if (Permissions.canManageReaders(role)) {
      items.add(
        const _NavItem(
          '/readers',
          'Читатели',
          Icons.badge_outlined,
          Icons.badge,
        ),
      );
    }
    if (Permissions.canManageUsers(role)) {
      items.add(
        const _NavItem(
          '/admin/users',
          'Пользователи',
          Icons.manage_accounts_outlined,
          Icons.manage_accounts,
        ),
      );
    }
    if (Permissions.canViewStats(role)) {
      items.add(
        const _NavItem(
          '/admin/stats',
          'Статистика',
          Icons.bar_chart_outlined,
          Icons.bar_chart,
        ),
      );
    }
    return items;
  }

  int _selectedIndex(String location, List<_NavItem> destinations) {
    for (var i = 0; i < destinations.length; i++) {
      final path = destinations[i].path;
      if (path == '/') {
        if (location == '/') return i;
      } else if (location.startsWith(path)) {
        return i;
      }
    }
    return 0;
  }
}

class _NavItem {
  const _NavItem(this.path, this.label, this.icon, this.selectedIcon);

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
