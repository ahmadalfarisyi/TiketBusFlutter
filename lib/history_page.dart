import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    List<String> urls = [
      'http://127.0.0.1:8000/api/transaksi',
      'http://10.0.2.2:8000/api/transaksi',
    ];

    bool success = false;

    for (String url in urls) {
      if (await _tryFetch(url)) {
        success = true;
        break;
      }
    }

    if (!success) {
      String hostIP = await _getHostIP();
      await _tryFetch('http://$hostIP:8000/api/transaksi');
        }
  }

  Future<bool> _tryFetch(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 0) {
          setState(() {
            _transactions = result['data'];
          });
          return true;
        } else {
          _showErrorDialog('Error fetching data: ${result['info']}');
        }
      } else {
        _showErrorDialog(
            'Failed to load transactions with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching from $url: $e');
    }
    return false;
  }

  Future<String> _getHostIP() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.address.startsWith('192.168') ||
              addr.address.startsWith('10.')) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      print('Error fetching host IP: $e');
    }
    _showErrorDialog('Unable to determine host IP');
    return "null";
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, dynamic transaction) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true, // Enable scrolling within the bottom sheet
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    'Detail Transaksi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildDetailRow(Icons.code, 'Kode', transaction['kode']),
                  _buildDetailRow(Icons.location_on, 'Tujuan',
                      transaction['rute']['tujuan']),
                  _buildDetailRow(Icons.person, 'Penumpang',
                      transaction['penumpang']['name']),
                  _buildDetailRow(Icons.chair, 'Kursi', transaction['kursi']),
                  _buildDetailRow(Icons.date_range, 'Tanggal Berangkat',
                      transaction['waktu']),
                  _buildDetailRow(Icons.attach_money, 'Total',
                      'Rp ${transaction['total']}'),
                  _buildDetailRow(Icons.payment, 'Status Pembayaran',
                      transaction['status']),
                  _buildDetailRow(Icons.route, 'Rute',
                      '${transaction['rute']['start']} - ${transaction['rute']['end']}'),
                  _buildDetailRow(Icons.timelapse, 'Waktu Rute',
                      transaction['rute']['jam']),
                  _buildDetailRow(Icons.calendar_today, 'Dibuat Pada',
                      transaction['created_at']),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Transaksi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _transactions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading:
                        Icon(Icons.receipt, color: Colors.blueAccent, size: 40),
                    title: Text(
                      'Kode Pemesanan: ${transaction['kode']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Tujuan: ${transaction['rute']['tujuan']}'),
                        Text('Penumpang: ${transaction['penumpang']['name']}'),
                        Text('Tanggal Berangkat: ${transaction['waktu']}'),
                      ],
                    ),
                    onTap: () => _showTransactionDetail(context, transaction),
                  ),
                );
              },
            ),
    );
  }
}
