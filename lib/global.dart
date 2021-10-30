import 'classes.dart';

Map<String, String> appSettings = {'theme': 'system'};
SearchHistory searchHistory = SearchHistory([]);
Account account = Account();
Orders globalOrders =
    Orders([Order('Создать диаграмму'), Order('Решить задачу')]);
Contacts globalContacts = Contacts([
  Contact('Илон Маск', [
    Message('Ты лох', 'Илон Маск', DateTime.now(), false),
    Message('Ты даун', 'Илон Маск', DateTime.now(), false),
    Message('Ты даун', 'Вы', DateTime.now(), true),
  ])
]);
