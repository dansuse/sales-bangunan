import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/resources/colors.dart';

class ProductTypeAddLayout extends StatefulWidget {

  @override
  _ProductTypeAddLayoutState createState() => _ProductTypeAddLayoutState();
}

class _ProductTypeAddLayoutState extends State<ProductTypeAddLayout> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _keyFormInsertType = GlobalKey<FormState>();
  TextEditingController _inputTypeNameController;
  TypeBloc _typeBloc;
  StreamSubscription<String> _blocOperationSubscription;

  @override
  void initState() {
    super.initState();
    _inputTypeNameController = TextEditingController();
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
          title: new Text("Input Tipe")
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: _keyFormInsertType,
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
                    StreamBuilder<ButtonState>(
                      stream: _typeBloc.outputButtonInsertTypeState,
                      initialData: ButtonState.IDLE,
                      builder: (context, snapshot) => new RaisedButton(
                        child: snapshot.data == ButtonState.IDLE
                            ? new Text('Tambahkan')
                            : const Text('PROCESSING'),
                        onPressed: snapshot.data == ButtonState.IDLE
                            ? () {
                          if (_keyFormInsertType.currentState
                              .validate()) {
                            _typeBloc.inputInsertType.add(
                                _inputTypeNameController.text
                                    .toString());
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
