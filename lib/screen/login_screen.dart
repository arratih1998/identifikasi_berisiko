import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan/screen/register_screen.dart';
import 'package:latihan/utils/dialog.dart';
import 'package:latihan/utils/validator.dart';

import '../menu.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(_) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, layout) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/bg8.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Material(
                color: Colors.transparent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Diagnosis ASD",
                        style: TextStyle(fontSize: 34.0),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Login Aplikasi",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 62.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.emailValidator,
                        onChanged: (d) => _email = d,
                        decoration: InputDecoration(
                          hintText: "Email",
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (d) => _password = d,
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      RaisedButton(
                        onPressed: _performLogin,
                        child: Text("Login"),
                      ),
                      SizedBox(
                        height: 62.0,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );

                          if (result ?? false)
                            Fluttertoast.showToast(
                                msg: "Berhasil mendaftarkan",
                                toastLength: Toast.LENGTH_LONG);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tidak memiliki akun ?, daftar di sini",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  _performLogin() async {
    if (!_formKey.currentState.validate()) return;

    LoadingDialog("Mohon tunggu...", context).Show();

    final result = await ApiServices().loginUser(_email, _password);

    Navigator.of(context).pop();
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          maintainState: false,
          builder: (context) => HelloMenuScreen(),
        ),
      );
    } else {
      MessageDialog("Masuk Aplikasi",
              "Email dan password yang kamu masukan tidak ditemukan", context)
          .Show();
    }
  }
}
