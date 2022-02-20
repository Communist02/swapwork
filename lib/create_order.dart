import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';
import 'firebase.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = '';
    String description = '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            actions: [
              IconButton(
                onPressed: () async {
                  final CloudStore cloudStore = CloudStore();
                  final Order order = Order(
                    title,
                    description,
                    account.id.toString(),
                    account.nickname,
                    DateTime.now(),
                  );
                  await cloudStore.addOrder(order);
                  globalOrders.orders.insert(0, order);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Заказ создан'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Создание заказа',
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
              //centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Тема',
                    hintText: 'Например: Решить задачу на Python',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: TextFormField(
                  minLines: 6,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    hintText:
                        'Например:\nНаписать код, который переводит целое число в строку, при том что его можно применить в любой системе счисления.',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
