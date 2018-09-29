import 'package:salbang/drawer_items.dart';

class DrawerListItemData{
  DrawerListItemData(){}
  final List<DrawerItems> data = <DrawerItems>[
    DrawerItems(
      'Katalog',
      children: <DrawerItems>[
        new DrawerItems('Produk', index: 0),
        new DrawerItems('Merk Produk', index: 1),
        new DrawerItems('Jenis Produk', index: 2),
      ],
    ),
    DrawerItems(
      'Master',
      children: <DrawerItems>[
        DrawerItems('Produk', index: 3),
        DrawerItems('Merk Produk', index: 4),
        DrawerItems('Jenis Produk', index: 5),
        DrawerItems('Ukuran Produk', index: 6),
      ],
    ),
  ];

  List<DrawerItems> drawerContainer(){
    return data;
  }

}