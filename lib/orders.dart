import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'classes.dart';
import 'global.dart';
import 'order.dart';
import 'firebase.dart';

bool _refresh = false;

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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _refresh = true;
          setState(() {});
        },
        child: ordersView(),
      ),
    );
  }
}

class OrderView extends StatelessWidget {
  final Order order;

  const OrderView(this.order, {Key? key}) : super(key: key);

  String dateTime(DateTime dateTime) {
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPage(order),
          ),
        );
      },
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
                      dateTime(order.dateTime),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption!.color,
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

Widget ordersView() {
  final CloudStore _cloudStore = CloudStore();

  if (globalOrders.orders.isNotEmpty && !_refresh) {
    return ListView.builder(
      key: const PageStorageKey('MyOrders'),
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: globalOrders.orders.length,
      itemBuilder: (context, int i) {
        return OrderView(globalOrders.orders[i]);
      },
    );
  }
  _refresh = false;
  return FutureBuilder(
    future: _cloudStore.getOrders(),
    initialData: globalOrders,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return const Center(child: Text('Нет сети'));
        case ConnectionState.waiting:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка'));
          } else {
            globalOrders = snapshot.data;
            return ListView.builder(
              key: const PageStorageKey('MyOrders'),
              padding: const EdgeInsets.symmetric(vertical: 5),
              itemCount: snapshot.data.orders.length,
              itemBuilder: (context, int i) {
                return OrderView(snapshot.data.orders[i]);
              },
            );
          }
      }
    },
  );
}
