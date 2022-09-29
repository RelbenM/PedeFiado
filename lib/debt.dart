import 'package:crudsqlite/services/helpers/database_helper.dart';
import 'package:flutter/material.dart';

class Debts extends StatefulWidget {
  const Debts({super.key});

  @override
  State<Debts> createState() => _DebtsState();
}

class _DebtsState extends State<Debts> {
  // All data
  List<Map<String, dynamic>> myData = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the data when the app starts
  }

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showMyForm(int? debt_id) async {
    if (debt_id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingData =
          myData.firstWhere((element) => element['debt_id'] == debt_id);
      _productController.text = existingData['product'];
      _priceController.text = existingData['price'];
      _statusController.text = existingData['status'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _productController,
                    decoration: const InputDecoration(hintText: 'Produto'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(hintText: 'Preço'),
                  ),
                  TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(hintText: 'Status'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new data
                      if (debt_id == null) {
                        await addDebt();
                      }

                      if (debt_id != null) {
                        await updateDebt(debt_id);
                      }

                      // Clear the text fields
                      _productController.text = '';
                      _priceController.text = '';
                      _statusController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(debt_id == null ? 'Inserir' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

// Insert a new data to the database
  Future<void> addDebt() async {
    await DatabaseHelper.createDebt(
      _productController.text,
      _priceController.text,
      _statusController.text,
    );
    _refreshData();
  }

  // Update an existing data
  Future<void> updateDebt(int debt_id) async {
    await DatabaseHelper.updateDebt(
      debt_id,
      _productController.text,
      _priceController.text,
      _statusController.text,
    );
    _refreshData();
  }

  // Delete an item
  void deleteDebt(int debt_id) async {
    await DatabaseHelper.deleteDebt(debt_id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Deletado com êxito!'), backgroundColor: Colors.green));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedeFiado'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myData.isEmpty
              ? const Center(child: Text("Nenhum cadastro ativo no momento..."))
              : ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) => Card(
                    color: index % 2 == 0 ? Colors.green : Colors.green[200],
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                        title: Text(myData[index]['product']),
                        subtitle: Text(myData[index]['price']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showMyForm(myData[index]['debt_id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    deleteDebt(myData[index]['debt_id']),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showMyForm(null),
      ),
    );
  }
}
