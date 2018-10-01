import 'dart:async';

import 'package:path/path.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/database/table_schema/brand.dart';
import 'package:salbang/database/table_schema/product.dart';
import 'package:salbang/database/table_schema/product_image.dart';
import 'package:salbang/database/table_schema/size.dart';
import 'package:salbang/database/table_schema/type.dart';
import 'package:salbang/database/table_schema/unit.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_image.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/product_unit.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database _db;
  static const String DATABASE_NAME = 'salbang.db';
  static const int DATABASE_VERSION = 1;
  static const int ID_FOR_INSERT = -22;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    print(databasesPath);
    final String path = join(databasesPath, DATABASE_NAME);
    final Database databaseInstance = await openDatabase(path, version: DATABASE_VERSION, onCreate: _onCreate);
    return databaseInstance;
  }

  void _onCreate(Database db, int version) async {
    final List<String> createTableQueries = [
      BrandTable.getCreateTableQuery(),
      SizeTable.getCreateTableQuery(),
      TypeTable.getCreateTableQuery(),
      UnitTable.getCreateTableQuery(),
      ProductTable.getCreateTableQuery(),
      ProductImageTable.getCreateTableQuery(),
    ];
    for(String query in createTableQueries){
      await db.execute(query);
    }
    await db.execute('CREATE UNIQUE INDEX pk_index ON "${ProductImageTable.NAME}"("${ProductImageTable.COLUMN_ID}","${ProductImageTable.COLUMN_FK_PRODUCT}")');
  }

  Future<Brand> insertOrUpdateBrand(Brand brand) async{
    final Database dbClient = await db;
    final Map<String, dynamic> dataToBeInserted = {
      BrandTable.COLUMN_NAME : brand.name,
      BrandTable.COLUMN_DESCRIPTION : brand.description,
      BrandTable.COLUMN_STATUS : brand.status,
    };
    if(brand.id != ID_FOR_INSERT){
      dataToBeInserted.addAll({
        BrandTable.COLUMN_ID : brand.id
      });
    }
    brand.id = await dbClient.insert(BrandTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
    return brand;
  }

  Future<Null> deleteBrand(int id)async{
    final Database dbClient = await db;
    final Map<String, dynamic> valueToBeUpdated = {
      BrandTable.COLUMN_STATUS: 0,
    };
    dbClient.update(BrandTable.NAME, valueToBeUpdated, 
        where: BrandTable.COLUMN_ID + ' = ?',
        whereArgs: [id]
    );
  }

  Future<ProductSize> insertOrUpdateSize(ProductSize size) async{
    final Database dbClient = await db;
    print(size.name + " dlm void");
    final Map<String, dynamic> dataToBeInserted = {
      SizeTable.COLUMN_NAME : size.name,
      SizeTable.COLUMN_STATUS : size.status,
    };
    if(size.id != ID_FOR_INSERT){
      dataToBeInserted.addAll({
        SizeTable.COLUMN_ID : size.id
      });
    }
    size.id = await dbClient.insert(SizeTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
    return size;
  }

  Future<Null> deleteSize(int id)async{
    final Database dbClient = await db;
    final Map<String, dynamic> valueToBeUpdated = {
      SizeTable.COLUMN_STATUS: 0,
    };
    dbClient.update(SizeTable.NAME, valueToBeUpdated,
        where: SizeTable.COLUMN_ID + ' = ?',
        whereArgs: [id]
    );
  }

  ///Contoh pemanggilan getProductsBy(2, ProductTable.COLUMN_FK_SIZE)
  Future<List<Product>> getProductsBy(int id, String foreignKeyColumnName)async{
    final Database dbClient = await db;
    final List<Map<String, dynamic>> queryResult = await dbClient.query(ProductTable.NAME,
      columns: ProductTable.getColumnList(),
      where: foreignKeyColumnName + ' = ?',
      whereArgs: [id],
      orderBy: ProductTable.COLUMN_NAME + ' ASC',
    );

    return queryResult.map((item){
      return Product(
        item[ProductTable.COLUMN_ID],
        item[ProductTable.COLUMN_NAME],
        item[ProductTable.COLUMN_PRICE],
        item[ProductTable.COLUMN_STOCK],
        item[ProductTable.COLUMN_DESCRIPTION],
        item[ProductTable.COLUMN_STATUS],
        item[ProductTable.COLUMN_SIZE],
        item[ProductTable.COLUMN_FK_BRAND],
        item[ProductTable.COLUMN_FK_TYPE],
        item[ProductTable.COLUMN_FK_UNIT],
        item[ProductTable.COLUMN_FK_SIZE],
      );
    }).toList();
  }

  Future<Null> insertOrUpdateType(ProductType type) async{
    final Database dbClient = await db;
    final Map<String, dynamic> dataToBeInserted = {
      TypeTable.COLUMN_NAME : type.name,
      TypeTable.COLUMN_STATUS : type.status,
    };
    if(type.id != ID_FOR_INSERT){
      dataToBeInserted.addAll({
        TypeTable.COLUMN_ID : type.id
      });
    }
    dbClient.insert(TypeTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Null> deleteType(int id)async{
    final Database dbClient = await db;
    final Map<String, dynamic> valueToBeUpdated = {
      TypeTable.COLUMN_STATUS: 0,
    };
    dbClient.update(TypeTable.NAME, valueToBeUpdated,
        where: TypeTable.COLUMN_ID + ' = ?',
        whereArgs: [id]
    );
  }

  Future<Null> insertOrUpdateUnit(ProductUnit unit) async{
    final Database dbClient = await db;
    final Map<String, dynamic> dataToBeInserted = {
      UnitTable.COLUMN_NAME : unit.name,
      UnitTable.COLUMN_STATUS : unit.status,
    };
    if(unit.id != ID_FOR_INSERT){
      dataToBeInserted.addAll({
        UnitTable.COLUMN_ID : unit.id
      });
    }
    dbClient.insert(UnitTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Null> deleteUnit(int id)async{
    final Database dbClient = await db;
    final Map<String, dynamic> valueToBeUpdated = {
      UnitTable.COLUMN_STATUS: 0,
    };
    dbClient.update(UnitTable.NAME, valueToBeUpdated,
        where: UnitTable.COLUMN_ID + ' = ?',
        whereArgs: [id]
    );
  }

  Future<Null> insertOrUpdateProduct(Product product) async{
    final Database dbClient = await db;
    final Map<String, dynamic> dataToBeInserted = {
      ProductTable.COLUMN_NAME : product.name,
      ProductTable.COLUMN_PRICE : product.price,
      ProductTable.COLUMN_STOCK : product.stock,
      ProductTable.COLUMN_DESCRIPTION : product.description,
      ProductTable.COLUMN_STATUS : product.status,
      ProductTable.COLUMN_SIZE : product.size,
      ProductTable.COLUMN_FK_BRAND : product.brandId,
      ProductTable.COLUMN_FK_UNIT : product.unitId,
      ProductTable.COLUMN_FK_TYPE : product.typeId,
      ProductTable.COLUMN_FK_SIZE : product.sizeId,
    };
    if(product.id != ID_FOR_INSERT){
      dataToBeInserted.addAll({
        ProductTable.COLUMN_ID : product.id
      });
    }
    dbClient.insert(ProductTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ResponseSalbang<List<ProductSize>>> getProductSizes() async {
    var dbClient = await db;
    final List<Map> list = await dbClient.query('size',
        columns: ['id', 'name', 'status']);
    if (list.length > 0) {
      List<ProductSize> _dataProductSize = new List();
      for (int i = 0; i < list.length; i++) {
        _dataProductSize.add(new ProductSize(list[i]['name'], id: list[i]['id'], status:list[i]['status'] ));
      }
      return ResponseSalbang(httpStatusCode: 400, result: 1, data: _dataProductSize,errorMessage: '');
    }
    return ResponseSalbang(httpStatusCode: 444, result: 0 , data: null ,errorMessage: 'Data Tidak Ditemukan');
  }

  Future<Null> addProductImages(List<ProductImage> images) async{
    final Database dbClient = await db;
    for(ProductImage image in images){
      final Map<String, dynamic> dataToBeInserted = {
        ProductImageTable.COLUMN_URL : image.url,
        ProductImageTable.COLUMN_STATUS : image.status,
        ProductImageTable.COLUMN_FK_PRODUCT : image.productId,
      };
      if(image.id != ID_FOR_INSERT){
        dataToBeInserted.addAll({
          ProductImageTable.COLUMN_ID : image.id
        });
      }
      dbClient.insert(ProductImageTable.NAME, dataToBeInserted, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<Null> deleteProductImagesById(List<int> ids) async{
    final Database dbClient = await db;
    for(int id in ids){
      dbClient.delete(ProductImageTable.NAME,
        where: ProductImageTable.COLUMN_ID + ' = ?',
        whereArgs: [id],
      );
    }
  }

  Future<Null> deleteProductImagesByProductId(int productId) async{
    final Database dbClient = await db;
    dbClient.delete(ProductImageTable.NAME,
      where: ProductImageTable.COLUMN_FK_PRODUCT + ' = ?',
      whereArgs: [productId],
    );
  }
}