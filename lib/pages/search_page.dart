import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text('Search Page',
          style: TextStyle(
            fontSize: 60,
            color: Colors.white,
          ),),
      ),
    );
  }
}
