import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';

class ProductSizeSettings extends StatefulWidget {
  @override
  _ProductSizeSettingsState createState() => _ProductSizeSettingsState();
}

class _ProductSizeSettingsState extends State<ProductSizeSettings> {
  TextEditingController _inputSizeController;
  bool _statusEnabled = true;
  @override
  void initState() {
    super.initState();
    _inputSizeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            body: new Container(
              padding: EdgeInsets.all(16.0),
              child: new ListView(
                children: <Widget>[
                  new TextFormField(
                    controller: _inputSizeController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: new BorderSide(color: colorBlack)),
                      labelText: "Ukuran Produk",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      new Checkbox(
                        activeColor: colorButton,
                        value: _statusEnabled,
                        onChanged: (bool newValue) {
                          setState(() {
                            _statusEnabled = newValue;
                          });
                        },
                      ),
                      Expanded(
                        child: new Text("Status Aktif Ukuran"),
                      )
                    ],
                  ),
                  new RaisedButton(
                    child: new Text("OK"),
                    onPressed: () {},
                  ),
                ],
              ),
            )));
  }
}
