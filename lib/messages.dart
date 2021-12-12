import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'classes.dart';
import 'global.dart';
import 'chat.dart';
import 'firebase.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщения'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_outlined),
      ),
      body: contactsView(),
    );
  }
}

class ContactView extends StatelessWidget {
  final Contact contact;

  const ContactView(this.contact, {Key? key}) : super(key: key);

  String dateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final DateTime timeNow = DateTime.now();
    final Duration difference = timeNow.difference(dateTime);
    if (difference.inMinutes < 1) {
      return difference.inSeconds.toString() + ' сек. назад';
    } else if (difference.inHours < 1) {
      return difference.inMinutes.toString() + ' мин. назад';
    } else if (difference.inDays < 1) {
      return difference.inHours.toString() + ' ч. назад';
    } else if (difference.inDays < 2) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return difference.inDays.toString() + ' д. назад';
    } else {
      return DateFormat('dd.MM.yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    Message? lastMessage = contact.lastMessage();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(contact),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 56,
              width: 56,
              child: FlutterLogo(),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            contact.nickname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          dateTime(lastMessage!.dateTime),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lastMessage.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

FutureBuilder contactsView() {
  final CloudStore _cloudStore = CloudStore();

  return FutureBuilder(
    future: _cloudStore.getContacts(),
    initialData: globalContacts,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return const Center(child: Text('Нет сети'));
        case ConnectionState.waiting:
          //return const Center(child: CircularProgressIndicator());
        case ConnectionState.active:
          //return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка'));
          } else {
            globalContacts = snapshot.data;
            return ListView.builder(
              key: const PageStorageKey('MyOrders'),
              padding: const EdgeInsets.symmetric(vertical: 5),
              itemCount: snapshot.data.contacts.length,
              itemBuilder: (context, int i) {
                return ContactView(snapshot.data.contacts[i]);
              },
            );
          }
      }
    },
  );
}
