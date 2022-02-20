import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state_update.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    if (context.watch<ChangeNavigation>().getSwitch) {
      _index = context.watch<ChangeNavigation>().getIndex;
    }
    return Scaffold(
      body: _page[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Сообщения',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            activeIcon: Icon(Icons.my_library_books),
            label: 'Мои заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Настройки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
