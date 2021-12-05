import 'package:flutter/material.dart';
import 'global.dart';
import 'firebase.dart';

bool _reg = false;
bool _reset = false;
String _email = '';
String _password = '';
String _password2 = '';
String _nickname = '';
final _formKey = GlobalKey<FormState>();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: account.id != null && !_reg
            ? Profile(callback)
            : _reg
                ? Registration(callback)
                : _reset
                    ? ResetPassword(callback)
                    : Login(callback),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  final Function callback;

  const Profile(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline_rounded, size: 100),
          minLeadingWidth: 100,
          title: Text(account.email!),
          minVerticalPadding: 40,
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
            ),
            child: const Text('ВЫЙТИ', style: TextStyle(fontSize: 15)),
            onPressed: () async {
              await _authService.signOut();
              account.clear();
              callback();
            },
          ),
        ),
      ],
    );
  }
}

class Login extends StatelessWidget {
  final Function callback;

  const Login(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Center(
            child: Text(
              'Вход',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                fontFamily: 'BalsamiqSans',
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 30),
          child: const Text(
            'Email',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'BalsamiqSans',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            initialValue: _email,
            decoration: InputDecoration(
              hintText: 'example.mail.com',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) => _email = value,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 14),
          child: const Text(
            'Пароль',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'BalsamiqSans',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 30),
          child: TextFormField(
            initialValue: _password,
            decoration: InputDecoration(
              hintText: 'Password123',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
            ),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (String value) => _password = value,
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),
            onPressed: () async {
              final AuthService _authService = AuthService();
              if (await _authService.signEmailPassword(_email, _password)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Вход выполнен успешно'),
                ));
                _email = '';
                _password = '';
                _password2 = '';
                callback();
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Вход не выполнен'),
                ));
              }
            },
            child: const Text('ВОЙТИ', style: TextStyle(fontSize: 15)),
          ),
        ),
        InkWell(
          onTap: () {
            _reset = true;
            callback();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: const Text(
              'Забыли пароль?',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _reg = true;
            callback();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: const Text(
              'Зарегистрироваться',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class Registration extends StatelessWidget {
  final Function callback;

  const Registration(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Center(
            child: Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                fontFamily: 'BalsamiqSans',
              ),
            ),
          ),
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 30),
                child: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'BalsamiqSans',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(
                    hintText: 'example.mail.com',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) => _email = value,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, top: 14),
                child: const Text(
                  'Никнейм',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'BalsamiqSans',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _nickname,
                  decoration: InputDecoration(
                    hintText: 'User123',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (String value) {
                    _nickname = value;
                    callback();
                  },
                  validator: (value) {
                    if (_nickname.length < 4) {
                      return 'Никнейм должен содержать не менее 4 символов';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, top: 14),
                child: const Text(
                  'Пароль',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'BalsamiqSans',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  initialValue: _password,
                  decoration: InputDecoration(
                    hintText: 'Password123',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (String value) {
                    _password = value;
                    callback();
                  },
                  validator: (value) {
                    if (_password.length < 6) {
                      return 'Пароль должен содержать не менее 6 символов';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, top: 14),
                child: const Text(
                  'Повторите пароль',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'BalsamiqSans',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: TextFormField(
                  initialValue: _password2,
                  enabled: _password.isNotEmpty,
                  decoration: InputDecoration(
                    hintText: 'Password123',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (String value) {
                    _password2 = value;
                  },
                  validator: (value) {
                    if (_password != _password2) return 'Пароли отличаются';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final AuthService _authService = AuthService();
                if (await _authService.registerEmailPassword(
                    _email, _password)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Регистрация прошла успешно'),
                  ));
                  _reg = false;
                  callback();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Регистрация не удалась'),
                  ));
                }
              }
            },
            child: const Text('ЗАРЕГИСТРИРОВАТЬСЯ',
                style: TextStyle(fontSize: 15)),
          ),
        ),
        InkWell(
          onTap: () {
            _reg = false;
            callback();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: const Text(
              'Войти',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class ResetPassword extends StatelessWidget {
  final Function callback;

  const ResetPassword(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Center(
            child: Text(
              'Сброс пароля',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                fontFamily: 'BalsamiqSans',
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, top: 30),
          child: const Text(
            'Email',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'BalsamiqSans',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            initialValue: _email,
            decoration: InputDecoration(
              hintText: 'example.mail.com',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) => _email = value,
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),
            onPressed: () async {
              final AuthService _authService = AuthService();
              if (await _authService.resetPassword(_email)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Инструкция выслана на ваш email'),
                ));
                callback();
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Неудача, проверьте ваш email'),
                ));
              }
            },
            child: const Text('ВОССТАНОВИТЬ', style: TextStyle(fontSize: 15)),
          ),
        ),
        InkWell(
          onTap: () {
            _reset = false;
            callback();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: const Text('Войти', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
