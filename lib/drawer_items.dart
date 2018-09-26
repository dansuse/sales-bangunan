import 'package:flutter/material.dart';

class DrawerItems{
  String title;
  int index;
  IconData icon;
  final List<DrawerItems> children;
  DrawerItems(this.title, { this.index, this.icon, this.children = const <DrawerItems>[]});

}