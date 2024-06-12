import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './history_page.dart';
import 'maps_page.dart';
// import 'detail_bus_page.dart'; // Import file halaman detail bus

void main() {
  runApp(MaterialApp(
    title: 'Go-Bus App',
    home: MyHomePage(title: 'Go-Bus'),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime _selectedDate = DateTime.now();
  String _selectedLocation = '';
  String _selectedClass = 'Ekonomi';

  final List<String> cities = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
  ];

  final List<String> classes = [
    'Ekonomi',
    'Bisnis',
    'Eksekutif',
  ];

  late TextEditingController _fromController = TextEditingController();
  late TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 183, 183, 183),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/bus.png',
              height: 65,
            ),
            SizedBox(width: 0),
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 420,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                    child: Text(
                      'Selamat Datang di Go-Bus',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 29, 36, 66),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      'Selalu lebih murah dari harga loket',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 29, 36, 66),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: TextField(
                            onTap: () => _selectLocation(context),
                            readOnly: true,
                            controller: _fromController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.directions_bus),
                              hintText: 'Dari',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.swap_horiz),
                        onPressed: () {
                          String temp = _fromController.text;
                          _fromController.text = _toController.text;
                          _toController.text = temp;
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: TextField(
                            onTap: () => _selectLocation(context),
                            readOnly: true,
                            controller: _toController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.directions_bus),
                              hintText: 'Ke',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      onTap: _pickDate,
                      readOnly: true,
                      controller: TextEditingController(text: formattedDate),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        hintText: formattedDate,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: DropdownButtonFormField<String>(
                      value: _selectedClass,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedClass = newValue!;
                        });
                      },
                      items: classes.map((String classType) {
                        return DropdownMenuItem<String>(
                          value: classType,
                          child: Text(classType),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.airline_seat_recline_normal),
                        hintText: 'Kelas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailBusPage(selectedClass: _selectedClass)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 25,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Lanjut',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  _buildBusCard(
                      'assets/images/buskelasA.jpg', 'Bus Kelas Ekonomi'),
                  SizedBox(width: 10),
                  _buildBusCard(
                      'assets/images/buskelasB.jpg', 'Bus Kelas Bisnis'),
                  SizedBox(width: 10),
                  _buildBusCard(
                      'assets/images/buskelasC.jpg', 'Bus Kelas Eksekutif'),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        height: 60,
        color: const Color.fromARGB(255, 183, 183, 183),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 29, 36, 66)),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.list, color: Color.fromARGB(255, 29, 36, 66)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Color.fromARGB(255, 29, 36, 66)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusCard(String imageUrl, String busType) {
    return Container(
      width: 120,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                busType,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocation(BuildContext context) {
    List<String> filteredCities = List.from(cities);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 500,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Cari Kota',
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredCities = cities
                              .where((city) => city
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(filteredCities[index]),
                          onTap: () {
                            setState(() {
                              _selectedLocation = filteredCities[index];
                              if (_fromController.text.isEmpty) {
                                _fromController.text = _selectedLocation;
                              } else {
                                _toController.text = _selectedLocation;
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage('assets/images/owner.jpg'),
            ),
            SizedBox(height: 50),
            Text(
              'FRAHWI TRAVEL',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Travel ini didirikan oleh 3 orang sekawan bernama Ahmad Alfarisyi, Fredyansyah, Alwi Hasyimi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailBusPage extends StatelessWidget {
  final String selectedClass;

  DetailBusPage({required this.selectedClass});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    String description = '';

    switch (selectedClass) {
      case 'Ekonomi':
        imageUrl = 'assets/images/buskelasA.jpg';
        description =
            'Bus kelas ekonomi memberikan kenyamanan yang terbaik dengan harga yang terjangkau.';
        break;
      case 'Bisnis':
        imageUrl = 'assets/images/buskelasB.jpg';
        description =
            'Bus kelas bisnis memberikan fasilitas yang lebih dari kelas ekonomi dengan harga yang terjangkau.';
        break;
      case 'Eksekutif':
        imageUrl = 'assets/images/buskelasC.jpg';
        description =
            'Bus kelas eksekutif memberikan pelayanan yang mewah dan kenyamanan yang maksimal.';
        break;
      default:
        imageUrl = '';
        description = '';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 183, 183, 183),
        title: Text('Detail Bus'),
      ),
      body: Container(
        color: Color.fromARGB(255, 222, 222, 222),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: Image.asset(
                          imageUrl,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              25), // Tambahkan jarak antara deskripsi dan tombol
                      ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman transaksi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionPage()),
                          );
                        },
                        child: Text('Konfirmasi Sewa'), // Text pada tombol
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phoneNumber;
  late String _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 183, 183, 183),
        title: Text('Transaksi'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Color.fromARGB(255, 222, 222, 222),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showTransactionInfo();
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informasi Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: $_name'),
              Text('Nomor Telepon: $_phoneNumber'),
              Text('Alamat: $_address'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()),
                );
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late String _review = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: '',
                        )),
              );
              // Kembali ke halaman sebelumnya (Homepage)
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'TERIMAKASIH TELAH MELAKUKAN PEMESANAN TIKET KEPADA KAMI, SAMPAI JUMPA!',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Ulasan',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showReviewDialog();
              },
              child: Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Demo Ulasan'),
          content: SingleChildScrollView(
            child: Text(
              _review.isEmpty ? 'Tidak ada ulasan' : _review,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
