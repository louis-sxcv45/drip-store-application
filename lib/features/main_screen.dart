import 'package:drip_store/provider/bottom_navigation_provider.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    final setIndex = context.watch<BottomNavigationProvider>().currentIndex;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(microseconds: 500),
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeInQuad,
        transitionBuilder: (Widget child, Animation<double> animation){
          return FadeTransition(opacity: animation, child: child,);
        },
        child: child,
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor:
            Theme.of(context).brightness == Brightness.light
                ? ColorsManager.white
                : ColorsManager.black,
        waterDropColor: ColorsManager.celestialBlue,
        barItems: [
          BarItem(filledIcon: Icons.home, outlinedIcon: Icons.home_outlined),
          BarItem(filledIcon: Icons.shopping_cart, outlinedIcon: Icons.shopping_cart_outlined),
          BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outlined),
        ],
        bottomPadding: AppPadding.p8,
        selectedIndex: setIndex,
        onItemSelected: (index) {
          context.read<BottomNavigationProvider>().setIndexNav(index);
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/cart');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
