import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salbang/bloc/cupertino_picker_bloc.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/cupertino_data.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/currency_input_formatter.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/global_widget/snackbar_builder.dart';
import 'package:flutter/painting.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class ProductSettings extends StatefulWidget {
  final Product product;
  ProductSettings(this.product);
  @override
  _ProductSettingsState createState() => _ProductSettingsState();
}

class _ProductSettingsState extends State<ProductSettings> {
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();
  TextEditingController _inputProductNameController;
  TextEditingController _inputProductPriceController;
  TextEditingController _inputProductStockController;
  TextEditingController _inputProductDescriptionController;
  TextEditingController _inputProductSizeController;

  bool defaultProductStatus = false;
  //int _selectedColorIndex = 0;
  CupertinoPickerBloc _cupertinoPickerBloc;
  ProductBloc productBloc;
  StreamSubscription productOperationSubscription;
  List<File> _image;
  @override
  void initState() {
    super.initState();
    _image = new List<File>();
    _inputProductNameController = TextEditingController();
    _inputProductPriceController = TextEditingController();
    _inputProductStockController = TextEditingController();
    _inputProductDescriptionController = TextEditingController();
    _inputProductSizeController = TextEditingController();
    _cupertinoPickerBloc = CupertinoPickerBloc(DBHelper());
    if (widget.product == null) {
      _inputProductNameController.text = "Susu Cap Tiga";
      _inputProductPriceController.text = "200000";
      _inputProductStockController.text = "50";
      _inputProductDescriptionController.text = "mantap";
      _inputProductSizeController.text = "500";
      defaultProductStatus = true;
    } else {
      _inputProductNameController.text = widget.product.name;
      _inputProductPriceController.text = widget.product.price.toString();
      _inputProductStockController.text = widget.product.stock.toString();
      _inputProductDescriptionController.text = widget.product.description;
      _inputProductSizeController.text = widget.product.size.toString();
      defaultProductStatus = widget.product.status == 1 ? true : false;
      _cupertinoPickerBloc.initializeBrand(widget.product.brandId);
      _cupertinoPickerBloc.initializeType(widget.product.typeId);
      _cupertinoPickerBloc.initializeSize(widget.product.sizeId);
      print("init state terpanggil untuk product tidak null");
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void dispose() {
    _inputProductNameController.dispose();
    _inputProductPriceController.dispose();
    _inputProductStockController.dispose();
    _inputProductDescriptionController.dispose();
    _inputProductSizeController.dispose();
    _cupertinoPickerBloc.dispose();
    super.dispose();
  }

  Future<void> initBloc() async {
    if (productOperationSubscription != null) {
      await productOperationSubscription.cancel();
    }
    productBloc = ProductBloc(DBHelper());
    productBloc.outputOperationResult.listen((response) {
      _keyScaffold.currentState.showSnackBar(
          SnackbarBuilder.getSnackbar(response.message, StringConstant.OK));
    });
  }

  Future getImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    _image.add(image);

    for (var x in _image) {
      print(x);
    }

    setState(() {});
  }

  Future<void> chooseCameraOrGallery() async {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text(
                  "Camera",
                  style: Theme.of(context).primaryTextTheme.display2,
                ),
                onTap: () {
                  getImage(ImageSource.camera);
                },
              ),
              new ListTile(
                leading: new Icon(
                  Icons.camera,
                ),
                title: new Text(
                  "Gallery",
                  style: Theme.of(context).primaryTextTheme.display2,
                ),
                onTap: () {
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    initBloc();
    if (widget.product == null) {
      _cupertinoPickerBloc.getBrandsStatusActive();
      _cupertinoPickerBloc.getSizesStatusActive();
      _cupertinoPickerBloc.getTypesStatusActive();
    }

    return new SafeArea(
        child: new Scaffold(
      key: _keyScaffold,
      appBar: new AppBar(
        backgroundColor: colorAppbar,
        elevation: 0.0,
        title: new Text("Input Produk"),
      ),
      body: new CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height / 4
                  : MediaQuery.of(context).size.height / 2,
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
                      ],
                    ),
                  ),
                  new Expanded(
                    child: buildProductImageListWidget(),
                  ),
                ],
              ),
            ),
          ),
          new SliverToBoxAdapter(
            child: Container(
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
                    controller: _inputProductStockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorBlack)),
                      labelText: 'Stok Produk',
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
                  buildProductTypeCupertino(context),
                  const SizedBox(
                    height: 8.0,
                  ),
                  buildProductBrandCupertino(context),
                  const SizedBox(
                    height: 8.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 4,
                        child: new TextFormField(
                          controller: _inputProductSizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorBlack)),
                            labelText: 'Ukuran Produk',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      buildProductSizeCupertino(context),
                    ],
                  ),
                  buildProductStatusWidget(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  new StreamBuilder(
                    initialData: ButtonState.IDLE,
                    stream: productBloc.outputButtonState,
                    builder: (context, snapshot) => new RaisedButton(
                          child: snapshot.data == ButtonState.IDLE
                              ? const Text('Tambahkan')
                              : const Center(
                                  child: CircularProgressIndicator()),
                          onPressed: snapshot.data == ButtonState.LOADING
                              ? null
                              : () {
                                  onButtonPressed();
                                },
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void onButtonPressed() {
    if (!_cupertinoPickerBloc.selectedBrand.isEmpty() &&
        !_cupertinoPickerBloc.selectedType.isEmpty() &&
        !_cupertinoPickerBloc.selectedSize.isEmpty()) {
      productBloc.insertOrUpdateProduct(
          (widget.product == null) ? DBHelper.ID_FOR_INSERT : widget.product.id,
          _inputProductNameController.text,
          double.parse(_inputProductPriceController.text),
          int.parse(_inputProductStockController.text),
          _inputProductDescriptionController.text,
          int.parse(_inputProductSizeController.text),
          _cupertinoPickerBloc.selectedBrand.idInformation,
          _cupertinoPickerBloc.selectedSize.idInformation,
          _cupertinoPickerBloc.selectedType.idInformation);
    } else {
      _keyScaffold.currentState.showSnackBar(SnackbarBuilder.getSnackbar(
          "Pastikan merk, type, dan size tidak kosong", StringConstant.OK));
    }
  }

  Widget buildProductStatusWidget() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new StreamBuilder(
          initialData: defaultProductStatus,
          stream: productBloc.outputEntityStatus,
          builder: (context, snapshot) {
            return new Checkbox(
              activeColor: colorAltDarkGrey,
              value: snapshot.data,
              onChanged: (bool newValue) {
                productBloc.updateStatus(newValue);
              },
            );
          },
        ),
        Expanded(
          child: Text("Status Aktif Produk"),
        ),
      ],
    );
  }

  Widget buildProductBrandCupertino(BuildContext context) {
    return new StreamBuilder<ResponseDatabase<List<CupertinoData>>>(
      stream: _cupertinoPickerBloc.outputGetBrands,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (isRequestSuccess(snapshot.data)) {
            return new GestureDetector(
              onTap: snapshot.data.data.isEmpty
                  ? null
                  : () async {
                      await setupCupertinoModal(
                          snapshot.data.data,
                          _cupertinoPickerBloc.inputSelectBrand,
                          _cupertinoPickerBloc.selectedBrand.index);
                    },
              child: _buildMenu(<Widget>[
                const Text('Merk'),
                new StreamBuilder<CupertinoData>(
                  initialData: CupertinoData.empty(),
                  stream: _cupertinoPickerBloc.outputSelectBrand,
                  builder: (context, snapshotSelectedItem) =>
                      buildSelectedCupertinoItemText(
                          snapshotSelectedItem.data.information),
                ),
              ]),
            );
          } else if (snapshot.data.result ==
              ResponseDatabase.ERROR_SHOULD_RETRY) {
            return buildRetryWidget(_cupertinoPickerBloc.getBrandsStatusActive);
          }
        }
        return new Container();
      },
    );
  }

  Widget buildProductSizeCupertino(BuildContext context) {
    return new StreamBuilder<ResponseDatabase<List<CupertinoData>>>(
      stream: _cupertinoPickerBloc.outputGetSizes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (isRequestSuccess(snapshot.data)) {
            return new Expanded(
              flex: 2,
              child: FlatButton(
                onPressed: snapshot.data.data.isEmpty
                    ? null
                    : () async {
                        await setupCupertinoModal(
                          snapshot.data.data,
                          _cupertinoPickerBloc.inputSelectSize,
                          _cupertinoPickerBloc.selectedSize.index,
                        );
                      },
                child: new StreamBuilder<CupertinoData>(
                  initialData: CupertinoData.empty(),
                  stream: _cupertinoPickerBloc.outputSelectSize,
                  builder: (context, snapshotSelectedItem) =>
                      buildSelectedCupertinoItemText(
                          snapshotSelectedItem.data.information),
                ),
              ),
            );
          } else if (snapshot.data.result ==
              ResponseDatabase.ERROR_SHOULD_RETRY) {
            return buildRetryWidget(_cupertinoPickerBloc.getSizesStatusActive);
          }
        }
        return new Container();
      },
    );
  }

  Widget buildProductTypeCupertino(BuildContext context) {
    return new StreamBuilder<ResponseDatabase<List<CupertinoData>>>(
      stream: _cupertinoPickerBloc.outputGetTypes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (isRequestSuccess(snapshot.data)) {
            return new GestureDetector(
              onTap: snapshot.data.data.isEmpty
                  ? null
                  : () async {
                      await setupCupertinoModal(
                        snapshot.data.data,
                        _cupertinoPickerBloc.inputSelectType,
                        _cupertinoPickerBloc.selectedType.index,
                      );
                    },
              child: _buildMenu(<Widget>[
                const Text('Tipe'),
                new StreamBuilder<CupertinoData>(
                  initialData: CupertinoData.empty(),
                  stream: _cupertinoPickerBloc.outputSelectType,
                  builder: (context, snapshotSelectedType) {
                    return buildSelectedCupertinoItemText(
                        snapshotSelectedType.data.information);
                  },
                ),
              ]),
            );
          } else if (snapshot.data.result ==
              ResponseDatabase.ERROR_SHOULD_RETRY) {
            return buildRetryWidget(_cupertinoPickerBloc.getTypesStatusActive);
          }
        }
        return new Container();
      },
    );
  }

  bool isRequestSuccess(ResponseDatabase response) {
    return response.result == ResponseDatabase.SUCCESS ||
        response.result == ResponseDatabase.SUCCESS_EMPTY;
  }

  Widget buildSelectedCupertinoItemText(String selectedItem) {
    return Text(
      selectedItem,
      style: const TextStyle(color: CupertinoColors.inactiveGray),
      overflow: TextOverflow.fade,
      softWrap: false,
      textAlign: TextAlign.right,
    );
  }

  Widget buildRetryWidget(VoidCallback func) {
    return RaisedButton(
      child: const Text(StringConstant.MESSAGE_TAP_TO_RETRY),
      onPressed: func,
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

  Future<void> setupCupertinoModal(List<CupertinoData> data,
      StreamSink<int> onSelectedItem, int initialIndex) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(
            _buildCupertinoPicker(data, onSelectedItem, initialIndex));
      },
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
          onTap: () {
            Navigator.pop(context);
          },
          child: SafeArea(
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoPicker(
      List<CupertinoData> data, StreamSink<int> sinker, int initialIndex) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: initialIndex);
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: _kPickerItemHeight,
      backgroundColor: CupertinoColors.white,
      onSelectedItemChanged: (int index) {
        print("masukgoal1 -> " + index.toString());
        sinker.add(index);
      },
      children: List<Widget>.generate(
        data.length,
        (int index) {
          return new GestureDetector(
            child: Center(
              child: Text(data[index].information),
            ),
            onTap: () {
              print("masukgoal2 -> " + index.toString());
              sinker.add(index);
            },
          );
        },
      ),
    );
  }

  Widget buildProductImageListWidget() {
    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _image.length + 1,
        itemBuilder: (context, position) {
          return position == 0
              ? Column(
                  children: <Widget>[
                    new Expanded(
                      child: buildAddProductImageWidget(context),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    new Expanded(
                        child: buildDummyProductImage(context,
                            imagePath: _image[position - 1],
                            position: (position - 1))),
                  ],
                );
        });
  }

  Widget buildDummyProductImage(BuildContext context,
      {File imagePath, int position}) {
    return new Container(
        width: MediaQuery.of(context).size.width / 2,
        child: new Card(
          elevation: 0.0,
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image.file(imagePath),
              new Positioned(
                right: 0.0,
                child: new IconButton(
                    icon: new Icon(Icons.cancel), onPressed: () {
//                      var dir = new Directory(imagePath.toString());
                        imagePath.deleteSync(recursive: true);
                      _image.removeAt(position);
                      imageCache.clear();
                      setState(() {

                      });
                }),
              ),
            ],
          ),
        ));
  }

  Widget buildAddProductImageWidget(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width / 2,
      child: new Card(
        elevation: 0.0,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => chooseCameraOrGallery(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
