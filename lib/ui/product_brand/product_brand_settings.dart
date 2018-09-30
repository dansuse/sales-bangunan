import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/resources/colors.dart';
import 'package:rxdart/rxdart.dart';

class ProductBrandSettings extends StatefulWidget {
  @override
  _ProductBrandSettingsState createState() => _ProductBrandSettingsState();
}

class _ProductBrandSettingsState extends State<ProductBrandSettings> {
  final _keyFormInsertBrand = GlobalKey<FormState>();
  TextEditingController _inputBrandNameController;
  TextEditingController _inputBrandDescriptionController;
  BrandBloc _brandBloc;
  StreamSubscription<String> _blocOperationSubscription;
  @override
  void initState() {
    super.initState();
    _inputBrandNameController = TextEditingController();
    _inputBrandDescriptionController = TextEditingController();
    _inputBrandNameController.text = 'Produgen';
    _inputBrandDescriptionController.text = 'Brand Susu Lansia';
    _brandBloc = BrandBloc(DBHelper());
  }

  @override
  void dispose() {
    _inputBrandNameController.dispose();
    _inputBrandDescriptionController.dispose();
    _brandBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_blocOperationSubscription != null){
      _blocOperationSubscription.cancel();
    }
    _blocOperationSubscription = _brandBloc.outputOperationResult.listen((String message){
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
    return new SafeArea(child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: _keyFormInsertBrand,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new TextFormField(
                      controller: _inputBrandNameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: colorBlack)),
                        labelText: "Merk Produk",
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Kolom nama brand wajib diisi';
                        }
                      },
                    ),
                    const SizedBox(height: 8.0,),
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
                      validator: (value){
                        if(value.isEmpty){
                          return 'Kolom deskripsi brand wajib diisi';
                        }
                      },
                    ),
                    new Row(
                      children: <Widget>[
                        StreamBuilder<bool>(
                            stream: _brandBloc.outputBrandStatus,
                            initialData: true,
                            builder: (context, snapshot) =>
                              new Checkbox(
                                activeColor: colorButtonAdd,
                                value: snapshot.data,
                                onChanged: (bool newStatus) {
                                  _brandBloc.updateStatus(newStatus);
                                },
                              )
                        ),
                        Expanded(
                          child: new Text ("Status Aktif Merk"),
                        )

                      ],
                    ),
                    StreamBuilder<ButtonState>(
                        stream: _brandBloc.outputButtonInsertBrandState,
                        initialData: ButtonState.IDLE,
                        builder: (context, snapshot) =>
                          new RaisedButton(
                            child: snapshot.data == ButtonState.IDLE ? const Text('OK') : const Text('PROCESSING'),
                            onPressed: snapshot.data == ButtonState.IDLE ? () {
                              if(_keyFormInsertBrand.currentState.validate()){
                                _brandBloc.insertBrand(_inputBrandNameController.text, _inputBrandDescriptionController.text);
                              }
                            } : null,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
