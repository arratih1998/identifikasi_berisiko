import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latihan/utils/dialog.dart';
import 'package:latihan/utils/validator.dart';

import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();
  String _name;
  String _gender;
  String _email;
  String _password;

  List _listGender = ["Laki Laki", "Perempuan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar",
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      body: SafeArea(
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
              child: FocusScope(
                node: _focusNode,
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
                        "Mendaftar Baru",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 62.0,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80.0,
                            child: Text(
                              "Nama: ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validator.noEmptyValidator,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (d) => _name = d,
                              decoration: InputDecoration(
                                hintText: "Nama",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80.0,
                            child: Text(
                              "Jenis Kelamin:\t ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(top: 8.0),
                              height: 64.0,
                              child: DropdownButton(
                                hint: Text("Pilih Jenis Kelamin"),
                                value: _gender,
                                onTap: () => _focusNode.unfocus(),
                                items: _listGender.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80.0,
                            child: Text(
                              "Email:\t ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validator.emailValidator,
                              onChanged: (d) => _email = d,
                              decoration: InputDecoration(
                                hintText: "Email",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80.0,
                            child: Text(
                              "Password:\t ",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: Validator.noEmptyValidator,
                              onChanged: (d) => _password = d,
                              decoration: InputDecoration(
                                hintText: "Password",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
                      RaisedButton(
                        onPressed: _performRegister,
                        child: Text("Daftar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_gender == null) {
      MessageDialog("Mendaftar Baru",
              "Jenis kelamin harus diisi terlebih dahulu", context)
          .Show();
      return;
    }
    if (!_formKey.currentState.validate()) return;

    LoadingDialog("Mendaftarkan...", context).Show();

    final result = await ApiServices().registerUser(
        _name,
        _listGender.indexWhere((element) => element == _gender),
        _email,
        _password);

    Navigator.of(context).pop();
    if (result) {
      Navigator.of(context).pop(result);
    } else {
      MessageDialog("Mendaftar Baru",
              "Terjadi kesalahan saat membuat akun baru", context)
          .Show();
    }
  }
}
