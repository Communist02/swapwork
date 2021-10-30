import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;

  const ChatPage(this.contact, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(contact);
}

class _ChatPageState extends State<ChatPage> {
  final Contact contact;
  bool isChanged = false;
  FocusNode focusNode = FocusNode();

  _ChatPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                height: 32,
                width: 32,
                child: const FlutterLogo(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(child: Text('Поиск')),
              const PopupMenuItem(child: Text('Очистить чат')),
            ];
          }),
        ],
      ),
      body: ChatView(contact.chat),
      bottomSheet: ListTile(
        tileColor: Theme.of(context).cardColor,
        title: TextField(
          focusNode: focusNode,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration.collapsed(hintText: 'Сообщение'),
          onChanged: (value) {
            setState(() {
              value.isEmpty ? isChanged = false : isChanged = true;
            });
          },
        ),
        trailing: isChanged
            ? IconButton(
                onPressed: () {
                  setState(() {
                    focusNode.unfocus();
                  });
                },
                icon: const Icon(Icons.send),
              )
            : null,
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  final Message message;

  const MessageView(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isYou = message.isYou;
    return InkWell(
      onLongPress: () {},
      child: Row(
        mainAxisAlignment:
            isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            color:
                isYou ? Colors.deepPurpleAccent : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isYou ? const Radius.circular(15) : Radius.zero,
                bottomRight: isYou ? Radius.zero : const Radius.circular(15),
              ),
            ),
            margin: EdgeInsets.only(
                top: 6,
                bottom: 6,
                left: (isYou ? 100 : 6),
                right: (isYou ? 6 : 100)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.value,
                    style: TextStyle(
                      color: isYou ? Colors.white : null,
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm').format(message.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: isYou
                          ? Colors.white
                          : Theme.of(context).textTheme.caption!.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  final List<Message> chat;

  const ChatView(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget dateCard(DateTime date) {
      String text = '';
      DateTime dateNow = DateTime.now();
      if (date.day == dateNow.day &&
          date.month == dateNow.month &&
          date.year == dateNow.year) {
        text = 'Сегодня';
      } else if (date.year == dateNow.year) {
        text = DateFormat('dd.MM').format(date);
      } else {
        text = DateFormat('dd.MM.yyyy').format(date);
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Center(child: Text(text)),
            ),
          ),
        ],
      );
    }

    List<Widget> messagesList() {
      List<Widget> list = [];
      if (chat.isNotEmpty) {
        DateTime dateTMP = chat[0].dateTime;
        list.add(dateCard(dateTMP));

        for (final Message message in chat) {
          if (dateTMP.day != message.dateTime.day ||
              dateTMP.month != message.dateTime.month ||
              dateTMP.year != message.dateTime.year) {
            list.add(dateCard(message.dateTime));
            dateTMP = message.dateTime;
          }
          list.add(MessageView(message));
        }
      }
      return list;
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 50),
      children: messagesList(),
    );
  }
}
