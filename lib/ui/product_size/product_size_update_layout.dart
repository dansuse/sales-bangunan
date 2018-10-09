import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/resources/colors.dart';

class ProductSizeUpdateLayout extends StatefulWidget {
  ProductSize productSize;
  ProductSizeUpdateLayout({this.productSize});
  @override
  _ProductSizeUpdateLayoutState createState() => _ProductSizeUpdateLayoutState();
}

class _ProductSizeUpdateLayoutState extends State<ProductSizeUpdateLayout> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _keyFormInsertSize = GlobalKey<FormState>();
  TextEditingController _inputSizeNameController;
  SizeBloc _sizeBloc;
  StreamSubscription<String> _blocOperationSubscription;

  @override
  void initState() {
    super.initState();
    _inputSizeNameController = TextEditingController();
    _inputSizeNameController.text = widget.productSize.name;
    _sizeBloc = SizeBloc(DBHelper());
  }

  @override
  void dispose() {
    _inputSizeNameController.dispose();
    _sizeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_blocOperationSubscription != null) {
      _blocOperationSubscription.cancel();
    }
    _blocOperationSubscription =
        _sizeBloc.outputOperationResult.listen((String message) {
          _key.currentState.showSnackBar(SnackBar(content: Text(message)));
        });

    return new SafeArea(
      child: new Scaffold(
        key: _key,
        appBar: new AppBar(
          backgroundColor: colorAppbar,
          elevation: 0.0,
          title: new Text("Ubah Ukuran"),
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: _keyFormInsertSize,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new TextFormField(
                      controller: _inputSizeNameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: colorBlack)),
                        labelText: "Ukuran Produk",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4.0),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Kolom Nama Ukuran Wajib Diisi';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    new Row(
                      children: <Widget>[
                        StreamBuilder<bool>(
                            stream: _sizeBloc.outputSizeStatus,
                            initialData: widget.productSize.status == 1? true : false,
                            builder: (context, snapshot) => new Checkbox(
                              activeColor: colorButtonAdd,
                              value: snapshot.data,
                              onChanged: (bool newStatus) {
                                newStatus ? widget.productSize.status = 1 : widget.productSize.status = 0;
                                _sizeBloc.inputSizeStatus
                                    .add(newStatus);
                              },
                            )),
                        Expanded(
                          child: new Text("Status Aktif Ukuran"),
                        )
                      ],
                    ),
                    StreamBuilder<ButtonState>(
                      stream: _sizeBloc.outputButtonInsertSizeState,
                      initialData: ButtonState.IDLE,
                      builder: (context, snapshot) => new RaisedButton(
                        child: snapshot.data == ButtonState.IDLE
                            ? new Text('Ubah')
                            : const Text('PROCESSING'),
                        onPressed: snapshot.data == ButtonState.IDLE
                            ? () {
                          if (_keyFormInsertSize.currentState
                              .validate()) {
                            widget.productSize.name = _inputSizeNameController.text.toString();
                            _sizeBloc.inputUpdateSize.add(widget.productSize);
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
