import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salbang/bloc/cupertino_picker_bloc.dart';
import 'package:salbang/bloc/image_bloc.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/product_unit_dropdown_bloc.dart';
import 'package:salbang/cupertino_data.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_image.dart';
import 'package:salbang/model/product_unit.dart';
import 'package:salbang/model/product_variant.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/currency_input_formatter.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/global_widget/snackbar_builder.dart';

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
  TextEditingController _inputProductStockController;
  TextEditingController _inputProductDescriptionController;

  List<TextEditingController> inputPriceProductVariants = <TextEditingController>[];
  List<TextEditingController> inputTypeOrSizeProductVariants = <TextEditingController>[];

  bool defaultProductStatus = false;
  //int _selectedColorIndex = 0;
  CupertinoPickerBloc _cupertinoPickerBloc;
  ProductBloc productBloc;
  ImageBloc _imageBloc;
  StreamSubscription productOperationSubscription;
  List<ProductImage> _image;
  Color labelColor;
  Color selectedCupertinoColor;

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc(DBHelper());
    _imageBloc = ImageBloc(DBHelper());
    labelColor = Colors.black54;
    selectedCupertinoColor = CupertinoColors.black;
    _image = <ProductImage>[];
    _inputProductNameController = TextEditingController();

    _inputProductStockController = TextEditingController();
    _inputProductDescriptionController = TextEditingController();
    _cupertinoPickerBloc = CupertinoPickerBloc(DBHelper());
    if (widget.product == null) {
      _inputProductNameController.text = "Susu Cap Tiga";
      _inputProductStockController.text = "50";
      _inputProductDescriptionController.text = "mantap";
      defaultProductStatus = true;
    } else {
      _inputProductNameController.text = widget.product.name;
      _inputProductStockController.text = widget.product.stock.toString();
      _inputProductDescriptionController.text = widget.product.description;
      defaultProductStatus = widget.product.status == 1 ? true : false;
      _cupertinoPickerBloc.initializeBrand(widget.product.brandId);
      _cupertinoPickerBloc.initializeType(widget.product.typeId);
      print("init state terpanggil untuk product tidak null");
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void dispose() {
    _inputProductNameController.dispose();
    _inputProductStockController.dispose();
    _inputProductDescriptionController.dispose();
    _cupertinoPickerBloc.dispose();
    _imageBloc.dispose();
    productBloc.dispose();
    super.dispose();
  }

  Future<void> initBloc() async {
    if (productOperationSubscription != null) {
      await productOperationSubscription.cancel();
    }

    productOperationSubscription = productBloc.outputOperationResult.listen((response) {
      if(response.result == ResponseDatabase.SUCCESS) {
        _keyScaffold.currentState.showSnackBar(
            SnackbarBuilder.getSnackbar(response.message, StringConstant.OK));
        print("image length "  + _image.length.toString());
        if(_image.length > 0 && widget.product == null) {
          _imageBloc.insertImageIntoDatabase(_image, response.data.id);
        }
      }
    });

    _imageBloc.outputInsertImageResponse.listen((response) {
      if(response.result == ResponseDatabase.SUCCESS) {
        _keyScaffold.currentState.showSnackBar(
            SnackbarBuilder.getSnackbar(response.message, StringConstant.OK));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initBloc();
    if (widget.product == null) {
      _cupertinoPickerBloc.populateProductAttributes();
    }
    else{
      _imageBloc.getImageFromDatabase(widget.product.id);
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
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorBlack)),
                      labelText: 'Nama Produk',
                      labelStyle: TextStyle(color: labelColor),
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
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorBlack)),
                      labelText: 'Stok Produk',
                      labelStyle: TextStyle(color: labelColor),
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
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorBlack)),
                      labelText: 'Deskripsi Produk',
                      labelStyle: TextStyle(color: labelColor),
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
                  buildProductStatusWidget(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  StreamBuilder<List<ProductVariant>>(
                    initialData: const <ProductVariant>[],
                    stream: productBloc.outputProductVariants,
                    builder: (context, snapshot){
                      final List<Widget> productVariantCards = <Widget>[];
                      for(int i=0; i<snapshot.data.length; i++){
                        final ProductVariant variant = snapshot.data[i];
                        productVariantCards.add(
                          Container(
                            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      alignment: Alignment.center,
                                      child: FlatButton(
                                        child: const Icon(Icons.close),
                                        onPressed: (){
                                          productBloc.deleteProductVariant(i);
                                          inputPriceProductVariants.removeAt(i);
                                          inputTypeOrSizeProductVariants.removeAt(i);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                new TextFormField(
                                  controller: inputPriceProductVariants[i],
                                  onFieldSubmitted: (String value){
                                    productBloc.changeProductVariantPrice(i, value);
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    new CurrencyInputFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: colorBlack)),
                                    labelText: 'Harga Produk',
                                    labelStyle: TextStyle(
                                        color: labelColor
                                    ),
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: new TextFormField(
                                        controller: inputTypeOrSizeProductVariants[i],
                                        onFieldSubmitted: (String value){
                                          productBloc.changeProductVariantTypeOrSize(i, value);
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: colorBlack)),
                                          labelText: 'Ukuran Produk',
                                          labelStyle: TextStyle(color: labelColor),
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 0.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: StreamBuilder<DropdownProductUnit>(
                                        initialData: DropdownProductUnit(
                                          <ProductUnit>[],
                                        ),
                                        stream: variant.productUnitDropdownBloc.outputProductUnits,
                                        builder: (context, snapshot){
                                          if(snapshot.data.items.isNotEmpty){
                                            return new DropdownButton<ProductUnit>(
                                              items: snapshot.data.items.map((ProductUnit value) {
                                                return new DropdownMenuItem<ProductUnit>(
                                                  value: value,
                                                  child: new Text(value.name),
                                                );
                                              }).toList(),
                                              onChanged: (ProductUnit newValue) {
                                                variant.productUnitDropdownBloc.onDropdownChange(newValue);
                                              },
                                              value: snapshot.data.selectedValue,
                                            );
                                          }else{
                                            return Container(child: Text(StringConstant.NO_DATA_AVAILABLE));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        );
                      }
                      return Column(
                        children: productVariantCards,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  RaisedButton(
                    onPressed: (){
                      inputPriceProductVariants.add(TextEditingController());
                      inputTypeOrSizeProductVariants.add(TextEditingController());
                      productBloc.addProductVariant();
                    },
                    child: Icon(Icons.add),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  new StreamBuilder(
                    initialData: ButtonState.DISABLED,
                    stream: _cupertinoPickerBloc.outputButtonState,
                    builder: (context, snapshot) {
                      if (snapshot.data == ButtonState.IDLE) {
                        return new RaisedButton(
                          child: const Text('Tambahkan'),
                          onPressed: onButtonPressed,
                        );
                      } else if (snapshot.data == ButtonState.LOADING) {
                        return const RaisedButton(
                          child: Center(child: CircularProgressIndicator()),
                          onPressed: null,
                        );
                      } else if (snapshot.data == ButtonState.DISABLED) {
                        return const RaisedButton(
                          child: Text('Tambahkan'),
                          onPressed: null,
                        );
                      }
                    },
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
        !_cupertinoPickerBloc.selectedSize.isEmpty() &&
        _inputProductNameController.text.isNotEmpty &&
        _inputProductStockController.text.isNotEmpty &&
        _inputProductDescriptionController.text.isNotEmpty) {
      productBloc.insertOrUpdateProduct(
          (widget.product == null) ? DBHelper.ID_FOR_INSERT : widget.product.id,
          _inputProductNameController.text,
          int.parse(_inputProductStockController.text),
          _inputProductDescriptionController.text,
          _cupertinoPickerBloc.selectedBrand.idInformation,
          _cupertinoPickerBloc.selectedType.idInformation);
    } else {
      _keyScaffold.currentState.showSnackBar(SnackbarBuilder.getSnackbar(
          "Pastikan semua field terisi", StringConstant.OK));
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
                Text(
                  'Merk',
                  style: TextStyle(color: labelColor),
                ),
                new StreamBuilder<CupertinoData>(
                  initialData: CupertinoData.empty(),
                  stream: _cupertinoPickerBloc.outputSelectBrand,
                  builder: (context, snapshotSelectedItem) {
                    if (snapshotSelectedItem.data.isEmpty()) {
                      return buildSelectedCupertinoItemText(
                          "Tidak ada data merk");
                    } else {
                      return buildSelectedCupertinoItemText(
                          snapshotSelectedItem.data.information);
                    }
                  },
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
                  builder: (context, snapshotSelectedItem) {
                    if (snapshotSelectedItem.data.isEmpty()) {
                      return buildSelectedCupertinoItemText(
                          "Tidak ada data size");
                    } else {
                      return buildSelectedCupertinoItemText(
                          snapshotSelectedItem.data.information);
                    }
                  },
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
                Text(
                  'Tipe',
                  style: TextStyle(color: labelColor),
                ),
                new StreamBuilder<CupertinoData>(
                  initialData: CupertinoData.empty(),
                  stream: _cupertinoPickerBloc.outputSelectType,
                  builder: (context, snapshotSelectedItem) {
                    if (snapshotSelectedItem.data.isEmpty()) {
                      return buildSelectedCupertinoItemText(
                          "Tidak ada data type");
                    } else {
                      return buildSelectedCupertinoItemText(
                          snapshotSelectedItem.data.information);
                    }
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
      style: TextStyle(color: selectedCupertinoColor),
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
    return StreamBuilder<List<ProductImage>>(
        stream: _imageBloc.outputImageFilePath,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _image = snapshot.data;
           return new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length+1,
                itemBuilder: (context, position) {
                  return position == 0
                      ? new Column(
                    children: <Widget>[
                      new Expanded(
                        child: buildAddProductImageWidget(context),
                      ),
                    ],
                  )
                      : new Column(
                    children: <Widget>[
                      new Expanded(
                          child: buildProductImageWidget(context,
                              imagePath:snapshot.data[position-1].url,
                              position: position - 1)),
                    ],
                  );
                });
          }
           return new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, position) {
                  return position == 0
                      ? new Column(
                    children: <Widget>[
                      new Expanded(
                        child: buildAddProductImageWidget(context),
                      ),
                    ],
                  )
                      : new Column(
                    children: <Widget>[
                      new Expanded(
                          child: buildProductImageWidget(context,
                              imagePath: _image[position - 1].url,
                              position: position - 1)),
                    ],
                  );
                });

        });
  }

  Widget buildProductImageWidget(BuildContext context,
      {String imagePath, int position}) {
    print("buildProductImageWidget---> " + imagePath);
    String image = imagePath.replaceAll("File: ", "");
    image = image.replaceAll("'", "");
    File imageFile = new File(image);
    return new Container(
        width: MediaQuery.of(context).size.width / 2,
        child: new Card(
          elevation: 0.0,
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image.file(imageFile),
              new Positioned(
                right: 0.0,
                child: new IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () async {
                      if (widget.product == null) {
                        print("x1");
                        _imageBloc.deleteImageFilePath(position);
                      }
                      else if (widget.product != null) {
                        print("x2");
                        _imageBloc.deleteImageFilePath(position, productImage: _image[position]);
                      }
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

  Future<void> chooseCameraOrGallery() async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.camera_alt),
              title: new Text(
                "Camera",
                style: Theme.of(context).primaryTextTheme.display2,
              ),
              onTap: () {
                getImage(ImageSource.camera);
              },
            ),
            new ListTile(
              leading: const Icon(
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
      },
    );
  }

  Future getImage(ImageSource imageSource) async {
    final File image = await ImagePicker.pickImage(source: imageSource);
    if(image != null) {
      print("getImage---> " + image.toString());
      if(widget.product == null) {
        _imageBloc.inputImageFilePath.add(image);
      }
      else{
        _imageBloc.insertImageFilePath(image, product: widget.product);
      }
    }

//    if(image != null){
//      _image.add(image);
//      setState(() {});
//    }
  }
}
