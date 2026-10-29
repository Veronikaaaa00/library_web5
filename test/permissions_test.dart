import 'package:flutter_test/flutter_test.dart';
import 'package:library_web/core/permissions.dart';
import 'package:library_web/models/role.dart';

void main() {
  test('читатель видит каталог и свои выдачи, но не управляет', () {
    const role = Role.reader;
    expect(Permissions.canViewCatalog(role), isTrue);
    expect(Permissions.canViewOwnLoans(role), isTrue);
    expect(Permissions.canRenewOwnLoan(role), isTrue);
    expect(Permissions.canManageCatalog(role), isFalse);
    expect(Permissions.canManageReaders(role), isFalse);
    expect(Permissions.canManageLoans(role), isFalse);
    expect(Permissions.canManageUsers(role), isFalse);
    expect(Permissions.canHardDelete(role), isFalse);
  });

  test('библиотекарь управляет каталогом, читателями и выдачами', () {
    const role = Role.librarian;
    expect(Permissions.canManageCatalog(role), isTrue);
    expect(Permissions.canManageReaders(role), isTrue);
    expect(Permissions.canManageLoans(role), isTrue);
    expect(Permissions.canManageUsers(role), isFalse);
    expect(Permissions.canHardDelete(role), isFalse);
    expect(Permissions.canRestore(role), isFalse);
    expect(Permissions.canViewStats(role), isFalse);
  });

  test('админ имеет права библиотекаря плюс пользователей и hard delete', () {
    const role = Role.admin;
    expect(Permissions.canManageCatalog(role), isTrue);
    expect(Permissions.canManageLoans(role), isTrue);
    expect(Permissions.canManageUsers(role), isTrue);
    expect(Permissions.canHardDelete(role), isTrue);
    expect(Permissions.canRestore(role), isTrue);
    expect(Permissions.canViewStats(role), isTrue);
  });

  test('Role.atLeast сравнивает уровни', () {
    expect(Role.admin.atLeast(Role.librarian), isTrue);
    expect(Role.librarian.atLeast(Role.reader), isTrue);
    expect(Role.reader.atLeast(Role.librarian), isFalse);
    expect(Role.fromApi('librarian'), Role.librarian);
  });

  test('без роли всё закрыто кроме явных null-проверок', () {
    expect(Permissions.canViewCatalog(null), isFalse);
    expect(Permissions.canManageCatalog(null), isFalse);
    expect(Permissions.canManageUsers(null), isFalse);
    expect(Permissions.canHardDelete(null), isFalse);
  });

  test('админ и библиотекарь могут продлевать выдачи', () {
    expect(Permissions.canRenewOwnLoan(Role.admin), isTrue);
    expect(Permissions.canRenewOwnLoan(Role.librarian), isTrue);
  });
}
