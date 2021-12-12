class Order {
  String id;
  String title;
  String description;
  String idQuestioner;
  String nameQuestioner;
  DateTime dateTime = DateTime.now();

  Order(this.title, this.description, this.idQuestioner, this.nameQuestioner, this.dateTime, {this.id = ''});
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
  String idSender;
  String idRecipient;
  String value;
  DateTime dateTime;

  Message(this.idSender, this.idRecipient, this.value, this.dateTime);
}

class Contact {
  String id;
  String nickname;
  List<Message> chat;

  Contact(this.id, this.nickname, this.chat);

  Message? lastMessage() {
    if (chat.isNotEmpty) {
      return chat[chat.length - 1];
    } else {
      return null;
    }
  }

  addMessage(String idSender, String value) {
    chat.add(Message(idSender, nickname, value, DateTime.now()));
  }

  void sortMessages() {
     chat.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}

class Contacts {
  List<Contact> contacts;

  Contacts(this.contacts);

  bool addMessage(String idSender, idRecipient, String value) {
    for (Contact contact in contacts) {
      if (idRecipient == contact.id) {
        contact.addMessage(idSender, value);
        return true;
      }
    }
    return false;
  }

  bool addMessageX(Message message) {
    for (Contact contact in contacts) {
      if (message.idRecipient == contact.id) {
        contact.chat.add(message);
        return true;
      }
    }
    return false;
  }

  void addContact(Message message, String id, String name) {
    contacts.add(Contact(id, name, [message]));
  }

  void sortMessages() {
    for (int i = 0; i < contacts.length; i++) {
      contacts[i].chat.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
  }
}

class Account {
  String? id;
  String? email;
  String nickname = '';
  String avatar = '';

  void clear() {
    id = null;
    email = null;
    nickname = '';
    avatar = '';
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
