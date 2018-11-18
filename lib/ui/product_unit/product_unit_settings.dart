import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/unit_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/string_constant.dart';

class ProductSizeAddLayout extends StatefulWidget {
  @override
  _ProductSizeAddLayoutState createState() => _ProductSizeAddLayoutState();
}

class _ProductSizeAddLayoutState extends State<ProductSizeAddLayout> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final keyForm = GlobalKey<FormState>();
  TextEditingController nameController;
  UnitBloc unitBloc;
  StreamSubscription<String> _blocOperationSubscription;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    unitBloc = UnitBloc(DBHelper());
  }

  @override
  void dispose() {
    nameController.dispose();
    unitBloc.dispose();
    super.dispose();
  }

  void initBloc()async{
    if (_blocOperationSubscription != null) {
      await _blocOperationSubscription.cancel();
    }
    _blocOperationSubscription =
      unitBloc.outputDbOperationResult.listen((String message) {
        _key.currentState.showSnackBar(SnackBar(content: Text(message)));
      });
  }

  @override
  Widget build(BuildContext context) {
    initBloc();
    return new SafeArea(
      child: new Scaffold(
        key: _key,
        appBar: new AppBar(
          backgroundColor: colorAppbar,
          elevation: 0.0,
          title: new Text("Input ${StringConstant.UNIT}")
        ),
        body: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new ListView(
            children: <Widget>[
              new Form(
                key: keyForm,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: colorBlack)),
                        labelText: "Nama ${StringConstant.UNIT}",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4.0),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Kolom Nama ${StringConstant.UNIT} Wajib Diisi';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    StreamBuilder<ButtonState>(
                      stream: unitBloc.outputButtonState,
                      initialData: ButtonState.IDLE,
                      builder: (context, snapshot) => new RaisedButton(
                            child: snapshot.data == ButtonState.IDLE
                                ? const Text(StringConstant.INSERT)
                                : const Text(StringConstant.BUTTON_STATE_LOADING_LABEL),
                            onPressed: snapshot.data == ButtonState.IDLE
                                ? () {
                                    if (keyForm.currentState.validate()) {
                                      unitBloc.insertUnit(
                                          nameController.text.toString());
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
