import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';

class ProductTypeSettings extends StatefulWidget {
  @override
  _ProductTypSettingsState createState() => _ProductTypSettingsState();
}

class _ProductTypSettingsState extends State<ProductTypeSettings> {
  TextEditingController _inputTypeController;
  bool _statusEnabled = true;
  @override
  void initState() {
    super.initState();
    _inputTypeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputTypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                controller: _inputTypeController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: new BorderSide(color: colorBlack)),
                  labelText: "Tipe Produk",
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Checkbox(
                    activeColor: colorButtonAdd,
                    value: _statusEnabled,
                    onChanged: (bool newValue) {
                      setState(() {
                        _statusEnabled = newValue;
                      });
                    },
                  ),
                  Expanded(
                    child: new Text ("Status Aktif Tipe"),
                  )

                ],
              ),

              new RaisedButton(
                child: new Text("OK"),
                onPressed: () {
                },
              ),

            ],
          ),
        )));
  }
}
