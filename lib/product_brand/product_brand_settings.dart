import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';

class ProductBrandSettings extends StatefulWidget {
  @override
  _ProductBrandSettingsState createState() => _ProductBrandSettingsState();
}

class _ProductBrandSettingsState extends State<ProductBrandSettings> {
  TextEditingController _inputBrandController;
  TextEditingController _inputBrandDescriptionController;
  bool _statusEnabled = true;
  @override
  void initState() {
    super.initState();
    _inputBrandController = TextEditingController();
    _inputBrandDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _inputBrandController.dispose();
    _inputBrandDescriptionController.dispose();
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
                controller: _inputBrandController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: new BorderSide(color: colorBlack)),
                  labelText: "Merk Produk",
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                ),
              ),
              new SizedBox(height: 8.0,),
              new TextFormField(
                controller: _inputBrandDescriptionController,
                maxLines : 5,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: new BorderSide(color: colorBlack)),
                  labelText: "Deskripsi Merk Produk",
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
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
                    child: new Text ("Status Aktif Merk"),
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
