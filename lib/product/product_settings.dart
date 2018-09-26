import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/currency_input_formatter.dart';

class ProductSettings extends StatefulWidget {
  @override
  _ProductSettingsState createState() => _ProductSettingsState();
}

class _ProductSettingsState extends State<ProductSettings> {
  TextEditingController _inputProductNameController;
  TextEditingController _inputProductPriceController;
  TextEditingController _inputProductDescriptionController;
  bool _statusEnabled = false;
  @override
  void initState() {
    super.initState();
    _inputProductNameController = TextEditingController();
    _inputProductPriceController = TextEditingController();
    _inputProductDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputProductNameController.dispose();
    _inputProductPriceController.dispose();
    _inputProductDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                controller: _inputProductNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorBlack)),
                  labelText: 'Nama Produk',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                ),
              ),
              const SizedBox(height: 8.0,),
              new TextFormField(
                controller: _inputProductPriceController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter> [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new CurrencyInputFormatter(),
                  // Fit the validating format.
//                  new CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorBlack)),
                  labelText: 'Harga Produk',
                  prefix: Text('Rp. '),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),

                ),
              ),
              const SizedBox(height: 8.0,),
              new TextFormField(
                controller: _inputProductDescriptionController,
                maxLines : 5,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorBlack)),
                  labelText: 'Deskripsi Produk',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
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
                  const Expanded(
                    child: Text ('Status Aktif Produk'),
                  )

                ],
              ),
              new RaisedButton(
                child: const Text('OK'),
                onPressed: () {
                },
              ),

            ],
          ),
        )));
  }
}
