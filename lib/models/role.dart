enum Role {
  reader(1, 'reader', 'Читатель'),
  librarian(2, 'librarian', 'Библиотекарь'),
  admin(3, 'admin', 'Администратор');

  const Role(this.level, this.apiValue, this.label);

  final int level;
  final String apiValue;
  final String label;

  static Role fromApi(String? value) {
    return Role.values.firstWhere(
      (r) => r.apiValue == value,
      orElse: () => Role.reader,
    );
  }

  bool atLeast(Role other) => level >= other.level;
}
