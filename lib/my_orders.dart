import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'state_update.dart';
import 'classes.dart';
import 'create_order.dart';
import 'firebase.dart';
import 'global.dart';
import 'order.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final CloudStore _cloudStore = CloudStore();

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

  InkWell orderView(Order order) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPage(order),
          ),
        ).then((value) => setState(() {}));
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

  FutureBuilder ordersView() {
    return FutureBuilder(
      future: _cloudStore.getMyOrders(),
      initialData: globalMyOrders,
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
              globalMyOrders = snapshot.data;
              return ListView.builder(
                key: const PageStorageKey('MyOrders'),
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data.orders.length,
                itemBuilder: (context, int i) {
                  return orderView(snapshot.data.orders[i]);
                },
              );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateOrderPage(),
                ),
              ).then((value) => setState(() {}));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: account.id != null
          ? RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: ordersView(),
            )
          : const NotAccount(),
    );
  }
}

class NotAccount extends StatelessWidget {
  const NotAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: () => context.read<ChangeNavigation>().change(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person_outline_rounded, size: 150),
              Text(
                'Войдите в аккаунт',
                style: TextStyle(fontSize: 20, fontFamily: 'BalsamiqSans'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
