import 'package:flutter/material.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("name", style: TextStyle(fontSize: 17)),
              SizedBox(height: 10),
              Text("password", style: TextStyle(fontSize: 17)),
              SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }
}
