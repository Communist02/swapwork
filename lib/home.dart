import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
//import 'state_update.dart';
import 'orders.dart';
import 'my_orders.dart';
import 'settings.dart';
import 'messages.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final List<Widget> _page = [
    const OrdersPage(),
    const MessagesPage(),
    const MyOrdersPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    //if (context.watch<ChangeNavigation>().getSwitch) {
    //_index = context.watch<ChangeNavigation>().getIndex;
    //}
    return Scaffold(
      body: _page[_index],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _index,
        iconSize: 30,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        onItemSelected: (int index) {
          setState(() => _index = index);
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.receipt_outlined),
            title: const Text('Заказы', overflow: TextOverflow.ellipsis),
            activeColor: Colors.green,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.message_outlined),
            title: const Text('Сообщения', overflow: TextOverflow.ellipsis),
            activeColor: Colors.blue,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.my_library_books_outlined),
            title: const Text('Мои заказы', overflow: TextOverflow.ellipsis),
            activeColor: Colors.red,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings_outlined),
            title: const Text('Настройки', overflow: TextOverflow.ellipsis),
            activeColor: Colors.purple,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outlined),
            title: const Text('Профиль', overflow: TextOverflow.ellipsis),
            activeColor: Colors.orange,
            inactiveColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
          ),
        ],
      ),
    );
  }
}
