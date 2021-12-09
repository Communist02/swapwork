import 'classes.dart';

Map<String, String> appSettings = {'theme': 'system'};
SearchHistory searchHistory = SearchHistory([]);
Account account = Account();
Orders globalOrders = Orders([
  Order(
    'Создать диаграмму',
    'Нужно создать UML диаграмму по шаблону',
    'id00001',
    'Илон Маск',
    DateTime.now(),
  )
]);
Orders globalMyOrders = Orders([]);
Contacts globalContacts = Contacts([]);
