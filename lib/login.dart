import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFunction;

  Login(this.submitFunction);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFunction(
          _email.trim(), _password.trim(), _username.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Enter valid mail';
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'username contains at least 4 character';
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val!,
                    decoration: InputDecoration(labelText: 'username'),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 8) {
                      return 'password contains at least 8 character';
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val!,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 12),
                RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign up'),
                    onPressed: _submit),
                FlatButton(
                    child: Text(_isLogin
                        ? 'haven\'t an account, Create an account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
