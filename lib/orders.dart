import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'classes.dart';
import 'global.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
      ),
      body: const OrdersView(),
    );
  }
}

class OrderView extends StatelessWidget {
  final Order order;

  const OrderView(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime() {
      final DateTime timeOrder = order.dateTime;
      final DateTime timeNow = DateTime.now();
      String dateTime = '';
      final Duration difference = timeNow.difference(timeOrder);
      if (difference.inMinutes < 1) {
        dateTime = difference.inSeconds.toString() + ' сек. назад';
      }
      else if (difference.inHours < 1) {
        dateTime = difference.inMinutes.toString() + ' мин. назад';
      }
      else if (difference.inDays < 1) {
        dateTime = difference.inHours.toString() + ' ч. назад';
      }
      else if (difference.inDays < 7) {
        dateTime = difference.inDays.toString() + ' д. назад';
      }
      else {
        dateTime = DateFormat('dd.MM.yyyy').format(order.dateTime);
      }
      return dateTime;
    }

    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.nameQuestioner,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dateTime(),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: const PageStorageKey('Orders'),
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemCount: globalOrders.orders.length,
        itemBuilder: (context, int i) {
          return OrderView(globalOrders.orders[i]);
        });
  }
}
