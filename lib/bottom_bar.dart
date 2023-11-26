import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final void Function(int) onItemTap;
  final int currentIndex;
  const CustomBottomNavigationBar(
      {super.key, required this.onItemTap, required this.currentIndex});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_box),
      label: 'Create',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shuffle),
      label: 'Random',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      items: _bottomNavBarItems,
      onTap: widget.onItemTap,
      iconSize: 30,
      showUnselectedLabels: false,
      backgroundColor: Colors.grey[850],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.orange[800],
    );
  }
}
