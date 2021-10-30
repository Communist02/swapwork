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
    Message('Знай свое место, урод', 'Вы', DateTime.now(), true),
    Message('Твое место у параши, даун. Ты любишь кабачки? Я нет', 'Вы', DateTime.now(), true),
  ])
]);
