import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_image.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';

class ImageBloc implements BlocBase{
  final _inputImageFilePath = StreamController<File>();

  StreamSink<File> get inputImageFilePath => _inputImageFilePath.sink;

  final BehaviorSubject<List<ProductImage>> _outputImageFilePath = new BehaviorSubject<List<ProductImage>>();
  Observable<List<ProductImage>> get outputImageFilePath => _outputImageFilePath.stream;

  final BehaviorSubject<ResponseDatabase<int>> _outputInsertImageResponse = new BehaviorSubject<ResponseDatabase<int>>();
  Observable<ResponseDatabase<int>> get outputInsertImageResponse => _outputInsertImageResponse.stream;

  final BehaviorSubject<ResponseDatabase<List<ProductImage>>> _outputGetImageResponse = new BehaviorSubject<ResponseDatabase<List<ProductImage>>>();
  Observable<ResponseDatabase<List<ProductImage>>> get outputGetImageResponse => _outputGetImageResponse.stream;
  List<File> _image;
  List<ProductImage> productImages;
  DBHelper _dbHelper;
  bool sizeStatus = true;

  ImageBloc(this._dbHelper){
    _image = new List<File>();
    productImages = new List<ProductImage>();
    _inputImageFilePath.stream.listen(insertImageFilePath);
  }


  Future<void> insertImageFilePath(File imagePath, {Product product = null}) async{
    if(product == null) {
      ProductImage pImage = new ProductImage(url: imagePath.toString());

      productImages.add(pImage);
      _outputImageFilePath.add(productImages);
    }
    else{
      String image = imagePath.toString().replaceAll("File: ", "");
      image = image.replaceAll("'", "");
      ProductImage pImage = new ProductImage(url: image,productId: product.id);

      ResponseDatabase<int> responseDatabase =  await _dbHelper.addProductImage(pImage);
      _outputInsertImageResponse.add(responseDatabase);
      print("product image id -> " + responseDatabase.data.toString());
      pImage.id = responseDatabase.data;
      productImages.add(pImage);
      _outputImageFilePath.add(productImages);


    }
  }


  Future<void> deleteImageFilePath(int indexImagePath, {ProductImage productImage = null}) async{
    if(productImage != null)
    {
      print("Product Image id: " + productImage.id.toString());
      print("Product Image url: " + productImage.url);
      ResponseDatabase<int> responseDatabase = await
      _dbHelper.deleteProductImagesByProductId(productImage.id);
      print("Response Database deleteImageFilePath ->" + responseDatabase.data.toString());
      productImages.removeAt(indexImagePath);
    }
    else {
      productImages.removeAt(indexImagePath);
    }
    _outputImageFilePath.add(productImages);
  }
  void insertImageIntoDatabase(List<ProductImage> imagePaths, int productId)async{

    for(int i =0 ; i < imagePaths.length ; i ++)
    {
      String image = imagePaths[i].url.replaceAll("File: ", "");
      String image2 = image.replaceAll("'", "");
      print("insertImageIntoDatabase  -->> " + image2);
      imagePaths[i].url = image2;
      imagePaths[i].productId = productId;
//      productImages.add(new ProductImage(url :image, productId : productId));
    }
//    imagePaths.map((imagePath) {
//      productImages.add(new ProductImage(url : imagePath.toString(), productId : productId));
//      print(imagePath.toString() + " ---- " + productId.toString());
//    });

    ResponseDatabase<int> responseDatabase =  await _dbHelper.addProductImages(imagePaths);
    _outputInsertImageResponse.add(responseDatabase);
  }

  void getImageFromDatabase(int productId)async{
    ResponseDatabase<List<ProductImage>> responseDatabase =  await _dbHelper.getProductImagesByProductId(productId);

    if(responseDatabase.data!= null) {
      productImages = responseDatabase.data;
      _outputImageFilePath.add(productImages);
    }
    _outputGetImageResponse.add(responseDatabase);
  }

  @override
  void dispose() {
    _inputImageFilePath.close();
    _outputImageFilePath.close();

  }
}
