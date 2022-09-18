import 'package:flutter/material.dart';
import 'package:newwfirst/presentation/widgets/three_dot_menu.dart';

class HomeAppBar extends AppBar {
  final String _title;
  final bool _automaticallyImplyLeading;
  HomeAppBar(this._title, this._automaticallyImplyLeading)
      : super(
            centerTitle: true,
            title: Text(_title),
            automaticallyImplyLeading: _automaticallyImplyLeading,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              ThreeDotMenu()
            ]);
}
