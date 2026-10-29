import '../models/role.dart';

/// Клиентские правила UI. Сервер всё равно решает сам.
class Permissions {
  const Permissions._();

  static bool canViewCatalog(Role? role) => role != null;

  static bool canManageCatalog(Role? role) =>
      role != null && role.atLeast(Role.librarian);

  static bool canManageReaders(Role? role) =>
      role != null && role.atLeast(Role.librarian);

  static bool canManageLoans(Role? role) =>
      role != null && role.atLeast(Role.librarian);

  static bool canViewOwnLoans(Role? role) => role != null;

  static bool canRenewOwnLoan(Role? role) =>
      role == Role.reader || role != null && role.atLeast(Role.librarian);

  static bool canHardDelete(Role? role) => role == Role.admin;

  static bool canRestore(Role? role) => role == Role.admin;

  static bool canManageUsers(Role? role) => role == Role.admin;

  static bool canViewStats(Role? role) => role == Role.admin;
}
