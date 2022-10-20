import 'package:flutter/material.dart';
import 'package:flutter_booklist/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DATA PASIEN',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Color.fromARGB(255, 85, 42, 42)),
      home: const MyHomePage(title: 'DATA PASIEN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController ttlController = TextEditingController();
  TextEditingController umurController = TextEditingController();
  TextEditingController diagnosaController = TextEditingController();

  @override
  void initState() {
    refreshPatiens();
    super.initState();
  }

  // Collect Data from DB
  List<Map<String, dynamic>> patiens = [];
  void refreshPatiens() async {
    final data = await SQLHelper.getPatiens();
    setState(() {
      patiens = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(patiens);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: patiens.length,
          itemBuilder: (context, index) => Card(
                color: Colors.brown,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(patiens[index]['nama'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFFFFFFF))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal Lahir   : " + patiens[index]['ttl'],
                          style: TextStyle(
                              height: 2.5,
                              color: Color(0xFFFFFFFF))),
                      Text("Umur                  : " + patiens[index]['umur'],
                          style: TextStyle(
                            height: 1.4,
                              color: Color(0xFFFFFFFF))),
                      Text("Diagnosa           : " + patiens[index]['diagnosa'],
                        style: TextStyle(
                          height: 1.5,
                          color: Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => modalForm(patiens[index]['id']),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () => deletePatien(patiens[index]['id']),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //Function -> Add
  Future<void> addPatien() async {
    await SQLHelper.addPatien(namaController.text, ttlController.text,
        umurController.text, diagnosaController.text);
    refreshPatiens();
  }

  // Function -> Update
  Future<void> updatePatiens(int id) async {
    await SQLHelper.updatePatiens(id, namaController.text, ttlController.text,
        umurController.text, diagnosaController.text);
    refreshPatiens();
  }

  // Function -> Delete
  void deletePatien(int id) async {
    await SQLHelper.deletePatien(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Berhasil Menghapus Data")));
    refreshPatiens();
  }

  //Form Add
  void modalForm(int id) async {
    if (id != null) {
      final dataPatiens = patiens.firstWhere((element) => element['id'] == id);
      namaController.text = dataPatiens['nama'];
      ttlController.text = dataPatiens['ttl'];
      umurController.text = dataPatiens['umur'];
      diagnosaController.text = dataPatiens['diagnosa'];
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                            labelText: "Nama",
                            hintText: "Masukkan nama lengkap",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: ttlController,
                        decoration: InputDecoration(
                            labelText: "Tanggal Lahir",
                            hintText: "dd/mm/yyyy",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.brown),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: umurController,
                        decoration: InputDecoration(
                            labelText: "Umur",
                            hintText: "Cth: 20",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.brown),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                        controller: diagnosaController,
                        decoration: InputDecoration(
                            labelText: "Diagnosa",
                            hintText: "Cth: Anemia",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.brown),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(
                      height: 193,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addPatien();
                          } else {
                            await updatePatiens(id);
                          }

                          // await addPatien();
                          namaController.text = '';
                          ttlController.text = '';
                          umurController.text = '';
                          diagnosaController.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'Simpan' : 'Update'))
                  ],
                ),
              ),
            ));
  }
}
