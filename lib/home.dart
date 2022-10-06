import 'package:crudsqlite/services/constants.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedeFiado', style: kAppText),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/debtors');
              },
              icon: const Icon(Icons.people_rounded))
        ],
      ),
      body: Center(
          child: Column(
        children: [
          
          ],
      )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/debt');
          }),
    );
  }
}
