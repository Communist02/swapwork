import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global.dart';
import 'classes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> signEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    final CollectionReference accounts = firestore.collection('accounts');
    final acc = await accounts.doc(account.id).get();
    account.nickname = acc['nickname'];
    return true;
  }

  Future<bool> registerEmailPassword(
      String email, String password, String nickname) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;

    final CollectionReference accounts = firestore.collection('accounts');
    accounts.doc(account.id).set({'nickname': nickname});
    account.nickname = nickname;
    return true;
  }

  Future<bool> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  void sign() async {
    if (_auth.currentUser != null) {
      account.id = _auth.currentUser!.uid;
      account.email = _auth.currentUser!.email;
      final CollectionReference accounts = firestore.collection('accounts');
      final acc = await accounts.doc(account.id).get();
      account.nickname = acc['nickname'];
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  bool checkSign() {
    return _auth.currentUser != null;
  }

  String? getId() {
    return _auth.currentUser?.uid;
  }

// Stream<User> get currentUser {
//   return _auth.authStateChanges().map((User user) => user != null ? user : null);
// }
}

class CloudStore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Orders> getOrders() async {
    final CollectionReference ordersBase = firestore.collection('orders');
    final CollectionReference accountsBase = firestore.collection('accounts');
    final result = await ordersBase.get();
    List<Order> orders = [];
    for (var order in result.docs) {
      final acc = await accountsBase.doc(order['idQuestioner']).get();
      orders.add(Order(
        order['title'],
        order['description'],
        order['idQuestioner'],
        acc['nickname'],
        DateTime.fromMillisecondsSinceEpoch(order['dateTime'].seconds * 1000),
        id: order.id,
      ));
    }
    orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Orders(orders);
  }

  Future<Orders> getMyOrders() async {
    final CollectionReference ordersBase = firestore.collection('orders');
    final CollectionReference accountsBase = firestore.collection('accounts');
    final result = await ordersBase
        .where('idQuestioner', isEqualTo: account.id.toString())
        .get();
    List<Order> orders = [];
    for (var order in result.docs) {
      final acc = await accountsBase.doc(order['idQuestioner']).get();
      orders.add(Order(
        order['title'],
        order['description'],
        order['idQuestioner'],
        acc['nickname'],
        DateTime.fromMillisecondsSinceEpoch(order['dateTime'].seconds * 1000),
        id: order.id,
      ));
    }
    orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Orders(orders);
  }

  Future<Contacts> getContacts() async {
    final CollectionReference chatsBase = firestore.collection('messages');
    final CollectionReference accountsBase = firestore.collection('accounts');
    final firstMessagesResult = await chatsBase
        .where('idSender', isEqualTo: account.id.toString())
        .get();
    final secondMessagesResult = await chatsBase
        .where('idRecipient', isEqualTo: account.id.toString())
        .get();
    Contacts contacts = Contacts([]);
    for (final message in firstMessagesResult.docs) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        DateTime.fromMillisecondsSinceEpoch(message['dateTime'].seconds * 1000),
      );
      if (!contacts.addMessageX(messageTMP)) {
        final acc = await accountsBase.doc(messageTMP.idRecipient).get();
        contacts.addContact(messageTMP, messageTMP.idRecipient, acc['nickname']);
      }
    }
    for (final message in secondMessagesResult.docs) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        DateTime.fromMillisecondsSinceEpoch(message['dateTime'].seconds * 1000),
      );
      if (!contacts.addMessageX(messageTMP)) {
        final acc = await accountsBase.doc(messageTMP.idSender).get();
        contacts.addContact(
            messageTMP, messageTMP.idSender, acc['nickname']);
      }
    }
    contacts.sortMessages();
    return contacts;
  }

  Future<Contact> getContact(String idContact) async {
    final CollectionReference chatsBase = firestore.collection('messages');
    final CollectionReference accountsBase = firestore.collection('accounts');
    final acc = await accountsBase.doc(idContact).get();
    Contact contact = Contact(idContact, acc['nickname'], []);
    final firstMessagesResult = await chatsBase
        .where('idSender', isEqualTo: account.id.toString())
        .where('idRecipient', isEqualTo: idContact)
        .get();
    final secondMessagesResult = await chatsBase
        .where('idSender', isEqualTo: idContact)
        .where('idRecipient', isEqualTo: account.id.toString())
        .get();
    for (final message in firstMessagesResult.docs) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        DateTime.fromMillisecondsSinceEpoch(message['dateTime'].seconds * 1000),
      );
      contact.chat.add(messageTMP);
    }
    for (final message in secondMessagesResult.docs) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        DateTime.fromMillisecondsSinceEpoch(message['dateTime'].seconds * 1000),
      );
      contact.chat.add(messageTMP);
    }
    contact.sortMessages();
    return contact;
  }

  Future<bool> addMessage(Message message) async {
    final CollectionReference messagesBase = firestore.collection('messages');
    messagesBase.add({
      'idSender': message.idSender,
      'idRecipient': message.idRecipient,
      'value': message.value,
      'dateTime': message.dateTime,
    });
    return true;
  }

  Future<bool> addOrder(Order order) async {
    final CollectionReference ordersBase = firestore.collection('orders');
    ordersBase.add({
      'title': order.title,
      'description': order.description,
      'idQuestioner': order.idQuestioner,
      'dateTime': order.dateTime,
    });
    return true;
  }

  Future<bool> removeOrder(String id) async {
    final CollectionReference ordersBase = firestore.collection('orders');
    ordersBase.doc(id).delete();
    return true;
  }
}
