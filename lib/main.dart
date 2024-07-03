import 'package:agen_toko/ui/barang/BarangListPage.dart';
import 'package:agen_toko/ui/itempenjualan/ItemPenjualanListPage.dart';
import 'package:agen_toko/ui/pelanggan/CustomerListPage.dart';
import 'package:agen_toko/ui/penjualan/PenjualanListPage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: CustomerListPage(),
            item: ItemConfig(
              icon: Icon(Icons.accessibility),
              title: "Pelanggan",
            ),
          ),
          PersistentTabConfig(
            screen: BarangListPage(),
            item: ItemConfig(
              icon: Icon(Icons.add_business_rounded),
              title: "Barang",
            ),
          ),
          PersistentTabConfig(
            screen: ItemPenjualanListPage(),
            item: ItemConfig(
              icon: Icon(Icons.inventory_outlined),
              title: "Item Penjualan",
            ),
          ),
          PersistentTabConfig(
            screen: PenjualanListPage(),
            item: ItemConfig(
              icon: Icon(Icons.shopping_bag),
              title: "Penjualan",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}