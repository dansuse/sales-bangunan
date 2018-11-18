import 'package:salbang/drawer_items.dart';

class DrawerListItemData{
  static const int CATALOG_PRODUCT = 0;
  static const int CATALOG_BRAND = 1;
  static const int CATALOG_TYPE = 2;
  static const int CATALOG_UNIT = 3;
  static const int MASTER_PRODUCT = 4;
  static const int MASTER_BRAND = 5;
  static const int MASTER_TYPE = 6;
  static const int MASTER_UNIT = 7;

  DrawerListItemData();
  final List<DrawerItems> data = <DrawerItems>[
    DrawerItems(
      'Katalog',
      children: <DrawerItems>[
        DrawerItems('Produk', index: CATALOG_PRODUCT),
        DrawerItems('Merk(Brand) Produk', index: CATALOG_BRAND),
        DrawerItems('Jenis(Type) Produk', index: CATALOG_TYPE),
        DrawerItems('Satuan(Unit) Produk', index: CATALOG_UNIT),
      ],
    ),
    DrawerItems(
      'Master',
      children: <DrawerItems>[
        DrawerItems('Produk', index: MASTER_PRODUCT),
        DrawerItems('Merk(Brand) Produk', index: MASTER_BRAND),
        DrawerItems('Jenis(Type) Produk', index: MASTER_TYPE),
        DrawerItems('Satuan(Unit) Produk', index: MASTER_UNIT),
      ],
    ),
  ];

  List<DrawerItems> drawerContainer(){
    return data;
  }

}