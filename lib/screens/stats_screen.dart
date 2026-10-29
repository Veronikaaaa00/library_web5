import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/user_repository.dart';
import '../widgets/app_scaffold.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<Map<String, int>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<UserRepository>().stats();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Статистика',
      body: FutureBuilder<Map<String, int>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          final data = snapshot.data ?? {};
          final labels = {
            'books': 'Книги',
            'authors': 'Авторы',
            'readers': 'Читатели',
            'users': 'Пользователи',
            'activeLoans': 'Активные выдачи',
          };
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              for (final entry in labels.entries)
                ListTile(
                  title: Text(entry.value),
                  trailing: Text(
                    '${data[entry.key] ?? 0}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
