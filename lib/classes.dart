class Order {
  String title;
  String description;
  String nameQuestioner;
  DateTime dateTime = DateTime.now();

  Order(this.title, {this.description = '', this.nameQuestioner = 'Anonymous'});
}

class Orders {
  List<Order> orders;

  Orders(this.orders);

  void add(Order order) {
    orders.insert(0, order);
  }

  void clear() {
    orders.clear();
  }
}

class Message {
  String value;
  String sender;
  DateTime dateTime;
  bool isYou;

  Message(this.value, this.sender, this.dateTime, this.isYou);
}

class Contact {
  String name;
  List<Message> chat;

  Contact(this.name, this.chat);

  Message? lastMessage() {
    if (chat.isNotEmpty) {
      return chat[0];
    } else {
      return null;
    }
  }
}

class Contacts {
  List<Contact> contacts;

  Contacts(this.contacts);
}

class Account {
  String? id;
  String? email;

  void clear() {
    id = null;
    email = null;
  }
}

class SearchHistory {
  List<String> history = [];

  SearchHistory(this.history);

  void clear() {
    history.clear();
  }

  void add(String value) {
    if (value.isEmpty) return;
    for (int i = 0; i < history.length; i++) {
      if (history[i] == value) {
        history.removeAt(i);
        history.insert(0, value);
        return;
      }
    }
    history.insert(0, value);
    if (history.length > 10) {
      history.removeAt(history.length - 1);
    }
  }

  void delete(String value) {
    for (int i = 0; i < history.length; i++) {
      if (history[i] == value) {
        history.removeAt(i);
      }
    }
  }
}
