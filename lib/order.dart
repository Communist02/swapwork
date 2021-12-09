import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';
import 'firebase.dart';

class OrderPage extends StatefulWidget {
  final Order order;

  const OrderPage(this.order, {Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState(order);
}

class _OrderPageState extends State<OrderPage> {
  final Order order;

  _OrderPageState(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const FlutterLogo(),
                Text(
                  order.nameQuestioner,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8, right: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
              ),
              onPressed: () {
                order.idQuestioner != account.id
                    ? null
                    : showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Подтверждение удаления'),
                          content: const Text('Вы хотите удалить ваш заказ?'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'true'),
                              child: const Text('Да'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'false'),
                              child: const Text('Нет'),
                            ),
                          ],
                        ),
                      ).then((value) async {
                        if (value == 'true') {
                          final CloudStore cloudStore = CloudStore();
                          await cloudStore.removeOrder(order.id);
                          Navigator.pop(context);
                        }
                      });
              },
              child: order.idQuestioner == account.id
                  ? const Text('Удалить')
                  : const Text('Написать'),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              order.title,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(order.description),
          ),
        ],
      ),
    );
  }
}
