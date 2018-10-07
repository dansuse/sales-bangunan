import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/resources/colors.dart';

class ProductTypeUpdateLayout extends StatefulWidget {
  ProductType productType;

  ProductTypeUpdateLayout({this.productType});

  @override
  _ProductTypeUpdatLayoutState createState() => _ProductTypeUpdatLayoutState();
}

class _ProductTypeUpdatLayoutState extends State<ProductTypeUpdateLayout> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _keyFormUpdateType = GlobalKey<FormState>();
  TextEditingController _inputTypeNameController;
  TypeBloc _typeBloc;
  StreamSubscription<String> _blocOperationSubscription;

  @override
  void initState() {
    super.initState();
    _inputTypeNameController = TextEditingController();
    _inputTypeNameController.text = widget.productType.name;
    _typeBloc = TypeBloc(DBHelper());
  }

  @override
  void dispose() {
    _inputTypeNameController.dispose();
    _typeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_blocOperationSubscription != null) {
      _blocOperationSubscription.cancel();
    }
    _blocOperationSubscription =
        _typeBloc.outputOperationResult.listen((String message) {
          _key.currentState.showSnackBar(SnackBar(content: Text(message)));
        });

    return new SafeArea(
      child: new Scaffold(
        key: _key,
        appBar: new AppBar(
            backgroundColor: colorAppbar,
            elevation: 0.0,
            title: new Text("Update Tipe")
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: _keyFormUpdateType,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new TextFormField(
                      controller: _inputTypeNameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: colorBlack)),
                        labelText: "Tipe Produk",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4.0),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Kolom Nama Tipe Wajib Diisi';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    new Row(
                      children: <Widget>[
                        StreamBuilder<bool>(
                            stream: _typeBloc.outputTypeStatus,
                            initialData: widget.productType.status == 1? true : false,
                            builder: (context, snapshot) => new Checkbox(
                              activeColor: colorButtonAdd,
                              value: snapshot.data,
                              onChanged: (bool newStatus) {
                                newStatus ? widget.productType.status = 1 : widget.productType.status = 0;
                                _typeBloc.inputTypeStatus
                                    .add(newStatus);
                              },
                            )),
                        Expanded(
                          child: new Text("Status Aktif Ukuran"),
                        )
                      ],
                    ),
                    StreamBuilder<ButtonState>(
                      stream: _typeBloc.outputButtonInsertTypeState,
                      initialData: ButtonState.IDLE,
                      builder: (context, snapshot) => new RaisedButton(
                        child: snapshot.data == ButtonState.IDLE
                            ? new Text('Ubah')
                            : const Text('PROCESSING'),
                        onPressed: snapshot.data == ButtonState.IDLE
                            ? () {
                          if (_keyFormUpdateType.currentState
                              .validate()) {
                            widget.productType.name = _inputTypeNameController.text.toString();
                            _typeBloc.inputUpdateType.add(widget.productType);
                          }
                        }
                            : null,
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
