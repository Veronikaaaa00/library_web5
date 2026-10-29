# library_web

Практическая работа 5: Аутентификация, роли и защита маршрутов.

Клиент библиотечной системы на Flutter Web: каталог книг и авторов.
Данные хранятся в памяти, условия отбора отражаются в адресе страницы.

## Запуск

```bash
flutter pub get
flutter run -d chrome --web-port=5556
```

## Примеры адресов

```text
/books?search=война&genreId=1&sort=year,desc&page=1&size=10
/authors?search=толстой&country=Россия&sort=lastName,asc&page=1
```

Для демонстрации состояния ошибки введите в поиск: `__error__`

## Проверки

```bash
flutter analyze
flutter test
flutter build web
```
