import 'package:flutter/material.dart';
import 'services/helpers/database_helper.dart';

class Debtors extends StatefulWidget {
  const Debtors({Key? key}) : super(key: key);

  @override
  State<Debtors> createState() => _DebtorsState();
}

class _DebtorsState extends State<Debtors> {
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

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showMyForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingData = myData.firstWhere((element) => element['id'] == id);
      _firstnameController.text = existingData['firstname'];
      _lastnameController.text = existingData['lastname'];
      _phoneController.text = existingData['phone'];
      _addressController.text = existingData['address'];
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
                    controller: _firstnameController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(hintText: 'Sobrenome'),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(hintText: 'Telefone'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'Endere??o'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new data
                      if (id == null) {
                        await addItem();
                      }

                      if (id != null) {
                        await updateItem(id);
                      }

                      // Clear the text fields
                      _firstnameController.text = '';
                      _lastnameController.text = '';
                      _phoneController.text = '';
                      _addressController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Inserir' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

// Insert a new data to the database
  Future<void> addItem() async {
    await DatabaseHelper.createItem(
        _firstnameController.text,
        _lastnameController.text,
        _phoneController.text,
        _addressController.text);
    _refreshData();
  }

  // Update an existing data
  Future<void> updateItem(int id) async {
    await DatabaseHelper.updateItem(
        id,
        _firstnameController.text,
        _lastnameController.text,
        _phoneController.text,
        _addressController.text);
    _refreshData();
  }

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'), backgroundColor: Colors.green));
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
                        title: Text(myData[index]['firstname']),
                        subtitle: Text(myData[index]['lastname']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showMyForm(myData[index]['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    deleteItem(myData[index]['id']),
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
