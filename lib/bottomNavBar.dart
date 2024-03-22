
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar(
      {super.key, required this.updateParent, required this.selectedIcon});

  final void Function(int) updateParent;

  final int selectedIcon;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    int selectedIconBar = widget.selectedIcon;
    return BottomNavigationBar(
      iconSize: 25,
      elevation: 0,
      currentIndex: selectedIconBar,
      backgroundColor: Colors.white,
      selectedItemColor: selectedIconBar==0?Colors.purple:Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10.0,
      unselectedFontSize: 8.0,
      showSelectedLabels: true,
      onTap: (val) {
        setState(() {
          selectedIconBar = val;
          widget.updateParent(val);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.note_alt_outlined),
          label: 'Notes',
          backgroundColor: Colors.white,

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today_outlined),
          label: 'To Do',
          backgroundColor: Colors.white,
        ),

      ],
    );
  }
}
