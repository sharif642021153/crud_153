import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  get jsonStr => null;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      var url = Uri.parse("https://642021154.pungpingcoding.online/api/login");
      var response = await http.post(
        url,
        body: jsonEncode({"email": email, "password": password}),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Successful login action
        print(response.body);
        var jsonString = jsonDecode(response.body);
        print(jsonStr['user']);
        print(jsonStr['token']);

        SharedPreferences _pref = await pref;
        _pref.setString('username', jsonStr['user']['name']);
        _pref.setInt('userid', jsonStr['user']['id']);
        _pref.setString('token', jsonStr['token']);
        // print("Login successful");
      }
      //  else {
      //   // Unsuccessful login action
      //   print("Login failed: ${response.statusCode}");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
