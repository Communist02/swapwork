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

