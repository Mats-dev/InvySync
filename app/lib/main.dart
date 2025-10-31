import 'package:flutter/material.dart';

void main() {
  runApp(VoorraadApp());
}

class VoorraadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slimme Voorraad',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DashboardScreen(),
    );
  }
}

class Product {
  String naam;
  int hoeveelheid;
  DateTime vervaldatum;
  String locatie;

  Product({
    required this.naam,
    required this.hoeveelheid,
    required this.vervaldatum,
    required this.locatie,
  });
}

class ApiService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Product(
        naam: 'Melk',
        hoeveelheid: 2,
        vervaldatum: DateTime.now().add(Duration(days: 2)),
        locatie: 'Koelkast',
      ),
      Product(
        naam: 'Brood',
        hoeveelheid: 1,
        vervaldatum: DateTime.now().add(Duration(days: 5)),
        locatie: 'Kast',
      ),
    ];
  }

  Future<void> updateProduct(Product product) async =>
      await Future.delayed(Duration(milliseconds: 300));
  Future<void> addProduct(Product product) async =>
      await Future.delayed(Duration(milliseconds: 300));
  Future<void> useProduct(Product product) async =>
      await Future.delayed(Duration(milliseconds: 300));
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Product> producten = [];
  final ApiService api = ApiService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final fetched = await api.fetchProducts();
    setState(() {
      producten = fetched;
      loading = false;
    });
  }

  Color _getCardColor(Product product) {
    if (product.vervaldatum.isBefore(DateTime.now()))
      return Colors.red.shade100;
    if (product.vervaldatum.isBefore(DateTime.now().add(Duration(days: 3))))
      return Colors.orange.shade100;
    return Colors.green.shade50;
  }

  void _useProduct(Product product) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bevestigen'),
        content: Text('Ben je zeker dat je dit artikel wilt gebruiken?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Nee'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Ja'),
          ),
        ],
      ),
    );

    if (confirm) {
      await api.useProduct(product);
      setState(() {
        product.hoeveelheid -= 1;
        if (product.hoeveelheid <= 0) producten.remove(product);
      });
    }
  }

  void _addOrMergeProduct(Product nieuwProduct) async {
    await api.addProduct(nieuwProduct);

    bool merged = false;
    for (var p in producten) {
      if (p.naam == nieuwProduct.naam &&
          p.locatie == nieuwProduct.locatie &&
          p.vervaldatum == nieuwProduct.vervaldatum) {
        setState(() {
          p.hoeveelheid += nieuwProduct.hoeveelheid;
        });
        merged = true;
        break;
      }
    }
    if (!merged) {
      setState(() {
        producten.add(nieuwProduct);
      });
    }
  }

  void _editProduct(Product product) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(editProduct: product),
      ),
    );
    if (edited != null) {
      await api.updateProduct(edited);
      setState(() {
        // check merge
        if (edited != product) producten.remove(product);
        _addOrMergeProduct(edited);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voorraad Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final nieuwProduct = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
              if (nieuwProduct != null) _addOrMergeProduct(nieuwProduct);
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : producten.isEmpty
          ? Center(child: Text('Geen producten'))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: producten.length,
              itemBuilder: (context, index) {
                final product = producten[index];
                return Card(
                  color: _getCardColor(product),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      product.naam,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Aantal: ${product.hoeveelheid}\nVervaldatum: ${product.vervaldatum.toLocal().toString().split(' ')[0]}\nLocatie: ${product.locatie}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduct(product),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.orange.shade700,
                          ),
                          onPressed: () => _useProduct(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  final Product? editProduct;
  AddProductScreen({this.editProduct});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController naamController;
  late TextEditingController hoeveelheidController;
  late TextEditingController locatieController;
  DateTime? vervaldatum;

  @override
  void initState() {
    super.initState();
    if (widget.editProduct != null) {
      naamController = TextEditingController(text: widget.editProduct!.naam);
      hoeveelheidController = TextEditingController(
        text: widget.editProduct!.hoeveelheid.toString(),
      );
      locatieController = TextEditingController(
        text: widget.editProduct!.locatie,
      );
      vervaldatum = widget.editProduct!.vervaldatum;
    } else {
      naamController = TextEditingController();
      hoeveelheidController = TextEditingController();
      locatieController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editProduct != null ? 'Bewerk Product' : 'Nieuw Product',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: naamController,
                decoration: InputDecoration(
                  labelText: 'Productnaam',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Vul een naam in' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: hoeveelheidController,
                decoration: InputDecoration(
                  labelText: 'Aantal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Vul een aantal in' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: locatieController,
                decoration: InputDecoration(
                  labelText: 'Locatie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Vul een locatie in' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    vervaldatum == null
                        ? 'Geen vervaldatum gekozen'
                        : 'Vervaldatum: ${vervaldatum!.toLocal().toString().split(' ')[0]}',
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final gekozenDatum = await showDatePicker(
                        context: context,
                        initialDate: vervaldatum ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (gekozenDatum != null)
                        setState(() => vervaldatum = gekozenDatum);
                    },
                    child: Text('Kies datum'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      vervaldatum != null) {
                    final product = Product(
                      naam: naamController.text,
                      hoeveelheid: int.parse(hoeveelheidController.text),
                      vervaldatum: vervaldatum!,
                      locatie: locatieController.text,
                    );
                    Navigator.pop(context, product);
                  }
                },
                child: Text(
                  widget.editProduct != null ? 'Opslaan' : 'Toevoegen',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
