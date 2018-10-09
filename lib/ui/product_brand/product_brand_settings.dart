import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/resources/colors.dart';

class ProductBrandSettings extends StatefulWidget {
  final Brand brand;
  ProductBrandSettings({this.brand});
  @override
  _ProductBrandSettingsState createState() => _ProductBrandSettingsState();
}

class _ProductBrandSettingsState extends State<ProductBrandSettings> {
  final GlobalKey<FormState> _keyFormInsertBrand = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();
  TextEditingController _inputBrandNameController;
  TextEditingController _inputBrandDescriptionController;
  BrandBloc _brandBloc;
  StreamSubscription<ResponseDatabase<Brand>> _blocOperationSubscription;
  bool _checkboxStatusInitialValue;
  @override
  void initState() {
    super.initState();
    _inputBrandNameController = TextEditingController();
    _inputBrandDescriptionController = TextEditingController();
    if(widget.brand != null){
      _inputBrandNameController.text = widget.brand.name;
      _inputBrandDescriptionController.text = widget.brand.description;
      _checkboxStatusInitialValue = widget.brand.status == 1 ? true : false;
    }else{
      _inputBrandNameController.text = 'Produgen';
      _inputBrandDescriptionController.text = 'Brand Susu Lansia';
      _checkboxStatusInitialValue = true;
    }
    _brandBloc = BrandBloc(DBHelper());
  }

  @override
  void dispose() {
    _inputBrandNameController.dispose();
    _inputBrandDescriptionController.dispose();
    if(_blocOperationSubscription != null){
      _blocOperationSubscription.cancel();
    }
    _brandBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_blocOperationSubscription != null){
      _blocOperationSubscription.cancel();
    }
    _blocOperationSubscription = _brandBloc.outputOperationResult.listen((ResponseDatabase<Brand> response){
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(response.message)));
    });
    return new SafeArea(
      child: new Scaffold(
        key: _keyScaffold,
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
                            initialData: _checkboxStatusInitialValue,
                            builder: (context, snapshot){
                              return new Checkbox(
                                activeColor: colorButtonAdd,
                                value: snapshot.data,
                                onChanged: (bool newStatus) {
                                  _brandBloc.updateStatus(newStatus);
                                },
                              );
                            }
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
                                if(widget.brand != null){
                                  _brandBloc.insertOrUpdateBrand(_inputBrandNameController.text, _inputBrandDescriptionController.text, widget.brand.id);
                                }else{
                                  _brandBloc.insertOrUpdateBrand(_inputBrandNameController.text, _inputBrandDescriptionController.text, DBHelper.ID_FOR_INSERT);
                                }
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
