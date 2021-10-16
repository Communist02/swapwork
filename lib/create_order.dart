import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({Key? key}) : super(key: key);

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            actions: [
              IconButton(
                onPressed: () {},
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
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
