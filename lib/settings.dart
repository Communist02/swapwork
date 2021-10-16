import 'package:flutter/material.dart';
import 'global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'state_update.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> changePrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: InkWell(
              child: ListTile(
                leading: const Icon(Icons.color_lens_outlined, size: 34),
                title: const Text('Тема приложения'),
                subtitle: Text(appSettings['theme'] == 'light'
                    ? 'Светлая тема'
                    : appSettings['theme'] == 'dark'
                        ? 'Темная тема'
                        : 'Системная тема'),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Тема приложения'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.wb_sunny_outlined),
                        title: const Text('Светлая тема'),
                        onTap: () => Navigator.pop(context, 'light'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.nights_stay_outlined),
                        title: const Text('Темная тема'),
                        onTap: () => Navigator.pop(context, 'dark'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone_android_outlined),
                        title: const Text('Системная тема'),
                        onTap: () => Navigator.pop(context, 'system'),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      changePrefs('theme', value);
                      appSettings['theme'] = value;
                      context.read<ChangeTheme>().change();
                    });
                  }
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: ListTile(
              leading: const Icon(Icons.sort_outlined, size: 34),
              title: const Text('Инверсия списка заказов'),
              subtitle: const Text('Список с наименьшей даты'),
              trailing: Switch(
                value: appSettings['ordersSort'] != 'up',
                onChanged: (bool value) {
                  setState(() {
                    String setting;
                    value ? setting = 'down' : setting = 'up';
                    changePrefs('ordersSort', setting);
                    appSettings['ordersSort'] = setting;
                  });
                },
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: const ListTile(
              title: Text('SwapWork'),
              subtitle: Text('Версия 0.1 Alpha'),
            ),
          ),
        ],
      ),
    );
  }
}
