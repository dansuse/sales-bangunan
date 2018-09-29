import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salbang/bloc/cupertino_picker_bloc.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/currency_input_formatter.dart';

const List<String> coolColorNames = <String>[
  'Sarcoline', 'Coquelicot', 'Smaragdine', 'Mikado', 'Glaucous', 'Wenge',
  'Fulvous', 'Xanadu', 'Falu', 'Eburnean', 'Amaranth', 'Australien',
  'Banan', 'Falu', 'Gingerline', 'Incarnadine', 'Labrador', 'Nattier',
  'Pervenche', 'Sinoper', 'Verditer', 'Watchet', 'Zaffre',
];
const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;
class ProductSettings extends StatefulWidget {
  bool addMode;
  ProductSettings({this.addMode});
  @override
  _ProductSettingsState createState() => _ProductSettingsState();
}

class _ProductSettingsState extends State<ProductSettings> {
  TextEditingController _inputProductNameController;
  TextEditingController _inputProductPriceController;
  TextEditingController _inputProductDescriptionController;
  TextEditingController _inputProductSizeController;
  bool _statusEnabled = false;
  @override
  void initState() {
    super.initState();
    _inputProductNameController = TextEditingController();
    _inputProductPriceController = TextEditingController();
    _inputProductDescriptionController = TextEditingController();
    _inputProductSizeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputProductNameController.dispose();
    _inputProductPriceController.dispose();
    _inputProductDescriptionController.dispose();
    _inputProductSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("- build product setting");

    CupertinoPickerBloc _cupertinoPickerBloc;
    Widget listContain(BuildContext context) {
      return new Container(
          width: MediaQuery.of(context).size.width/2,
          child : new Card(
            elevation: 0.0,
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Image.asset(
                    'assets/image/asset_no_image_available.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          )
      );
    }
    Widget listCamera(BuildContext context) {
      return new Container(
        width: MediaQuery.of(context).size.width/2,
        child: new Card(
          elevation: 0.0,
          child: new Column(
            children: <Widget>[
              new Expanded(
                child : new IconButton(icon: new Icon(Icons.add), onPressed: null),
              ),
            ],
          ),
        ),
      );
    }
    Widget horizontalList = new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, position) {
          return position == 0 ? Column(
            children: <Widget>[
              new Expanded(
                child: listCamera(context),
              ),
            ],
          ): Column(
            children: <Widget>[
              new Expanded(
                child: listContain(context),
              ),
            ],
          );
        });
    final Widget checkBoxSection = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Checkbox(
          activeColor: colorAltDarkGrey,
          value: _statusEnabled,
          onChanged: (bool newValue) {
            setState(() {
              _statusEnabled = newValue;
            });
          },
        ),
        Expanded(
          child: Text("Status Aktif Produk"),
        ),
      ],
    );
    int _selectedColorIndex = 0;

    Widget _buildColorPicker() {
      final FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: _selectedColorIndex);
      print("_buildColorPicker");
      return CupertinoPicker(
          scrollController: scrollController,
          itemExtent: _kPickerItemHeight,
          backgroundColor: CupertinoColors.white,
          onSelectedItemChanged: (int index) { _cupertinoPickerBloc.inputSelectBrand.add(index);

          },
          children: List<Widget>.generate(coolColorNames.length, (int index) {
        return Center(child:
        Text(coolColorNames[index]),
        );
      }),
      );
    }

    Widget _buildBottomPicker(Widget picker) {
      return Container(
        height: _kPickerSheetHeight,
        color: CupertinoColors.white,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 22.0,
          ),
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {print("picker pop");Navigator.pop(context);},
            child: SafeArea(
              child: picker,
            ),
          ),
        ),
      );
    }

    Widget _buildMenu(List<Widget> children) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
            bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          ),
        ),
        height: 44.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SafeArea(
            top: false,
            bottom: false,
            child: DefaultTextStyle(
              style: const TextStyle(
                letterSpacing: -0.24,
                fontSize: 17.0,
                color: CupertinoColors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children,
              ),
            ),
          ),
        ),
      );
    }

    _cupertinoPickerBloc = BlocProvider.of<CupertinoPickerBloc>(context);
    return new SafeArea(
      child: new Scaffold(
      appBar: new AppBar(
        backgroundColor: colorAppbar,
        elevation: 0.0,
        title: widget.addMode ? new Text("Input Produk") : new Text("Ubah Produk"),
      ),
      body: new CustomScrollView(
          shrinkWrap : true,
        slivers: <Widget>[
          new SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                  height: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.height / 4 :
                  MediaQuery.of(context).size.height / 2 ,
                  child: Column(
                    children: <Widget>[
                      new SizedBox(
                        height: 2.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Gambar Produk'),
                            Text('Lihat Semua > '),
                          ],
                        ),
                      ),
                      new Expanded(
                            child: horizontalList,
                          ),
                    ],
                  )),
              childCount: 1,
            ),
          ),
          new SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    padding: const EdgeInsets.all(16.0),
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          controller: _inputProductNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorBlack)),
                            labelText: 'Nama Produk',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        new TextFormField(
                          controller: _inputProductPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            new CurrencyInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorBlack)),
                            labelText: 'Harga Produk',
                            prefix: Text('Rp. '),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        new TextFormField(
                          controller: _inputProductDescriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorBlack)),
                            labelText: 'Deskripsi Produk',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildBottomPicker(_buildColorPicker());
                              },
                            );
                          },
                          child: _buildMenu(
                              <Widget>[
                                const Text('Merk'),
                                new StreamBuilder<int>(
                                  stream: _cupertinoPickerBloc.outputSelectBrand,
                                  builder: (context, snapshot) {
                                    return Text(snapshot.hasData ?  coolColorNames[snapshot.data] : coolColorNames[0],  style: const TextStyle(
                                        color: CupertinoColors.inactiveGray
                                    ),);
                                  },
                                ),

                              ]
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildBottomPicker(_buildColorPicker());
                              },
                            );
                          },
                          child: _buildMenu(
                              <Widget>[
                                const Text('Tipe'),
                                new StreamBuilder<int>(
                                  stream: _cupertinoPickerBloc.outputSelectBrand,
                                  builder: (context, snapshot) {
                                    return Text(snapshot.hasData ?  coolColorNames[snapshot.data] : coolColorNames[0],  style: const TextStyle(
                                        color: CupertinoColors.inactiveGray
                                    ),);
                                  },
                                ),

                              ]
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        new Row(
                          children: <Widget>[
                            new Expanded(flex : 4,child: new TextFormField(
                              controller: _inputProductNameController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: colorBlack)),
                                labelText: 'Ukuran Produk',
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                              ),

                            ),),
                            const SizedBox(width: 4.0,),
                            new Expanded(flex :2, child: FlatButton(
                              onPressed: () async {
                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _buildBottomPicker(_buildColorPicker());
                                  },
                                );
                              },
                              child:
                                    new StreamBuilder<int>(
                                      stream: _cupertinoPickerBloc.outputSelectBrand,
                                      builder: (context, snapshot) {
                                        return Text(snapshot.hasData ?  coolColorNames[snapshot.data] : coolColorNames[0],  style: const TextStyle(
                                            color: CupertinoColors.inactiveGray
                                        ),overflow: TextOverflow.fade,softWrap: false,textAlign: TextAlign.center,);
                                      },
                                    ),



                            ),),

                          ],
                        ),
                        widget.addMode
                            ?new Container() : checkBoxSection,
                        const SizedBox(
                          height: 8.0,
                        ),
                        new RaisedButton(
                          child: const Text('OK'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
              childCount: 1,
            ),
          ),
        ],
      ),
    ));
  }
}
