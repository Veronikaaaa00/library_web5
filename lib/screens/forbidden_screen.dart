import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/api_exceptions.dart';
import '../repositories/user_repository.dart';
import '../widgets/app_scaffold.dart';

class ForbiddenScreen extends StatefulWidget {
  const ForbiddenScreen({super.key});

  @override
  State<ForbiddenScreen> createState() => _ForbiddenScreenState();
}

class _ForbiddenScreenState extends State<ForbiddenScreen> {
  var _checking = false;
  String? _serverResult;

  Future<void> _probeServer() async {
    setState(() {
      _checking = true;
      _serverResult = null;
    });
    try {
      await context.read<UserRepository>().find(size: 1);
      if (!mounted) return;
      setState(() => _serverResult = 'Неожиданно: сервер разрешил запрос.');
    } on ForbiddenException catch (e) {
      setState(() => _serverResult = 'Сервер ответил 403: ${e.message}');
    } on ApiException catch (e) {
      setState(() => _serverResult = 'Ответ API: ${e.message}');
    } catch (e) {
      setState(() => _serverResult = 'Ошибка: $e');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Доступ запрещён',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Недостаточно прав для этого раздела',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Клиент остановил переход (redirect). '
                'Настоящий запрет подтвердит сервер кодом 403 — '
                'нажмите кнопку ниже и смотрите вкладку Network.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('На главную'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _checking ? null : _probeServer,
                icon: _checking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_off),
                label: const Text('Запросить /api/users у сервера'),
              ),
              if (_serverResult != null) ...[
                const SizedBox(height: 16),
                Text(
                  _serverResult!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
