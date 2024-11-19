import 'package:flutter/material.dart';
import 'dart:async';
import 'database_helper.dart';
import 'statistics_page.dart';
import 'edit_request_page.dart'; // Импорт страницы редактирования
import 'painting_page.dart'; // Импорт страницы покраски
import 'edit_painting_page.dart';

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});

  @override
  _DateTimeScreenState createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  String _currentDateTime = '';
  List<Map<String, dynamic>> repairRequests = [];
  List<Map<String, dynamic>> paintingRequests = [];
  Timer? _timer;

  bool _isRepairSortedAscending = true; // Состояние сортировки для заявок на ремонт
  bool _isPaintingSortedAscending = true; // Состояние сортировки для заявок на покраску

  @override
  void initState() {
    super.initState();
    _startTimer();
    _fetchData();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          DateTime now = DateTime.now();
          _currentDateTime =
              "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  Future<void> _markAsCompleted(int id) async {
    try {
      await DatabaseHelper().updateRepairStatus(id, 'выполнено');
      await _fetchData(); // Обновляем данные после изменения статуса
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Статус заявки обновлен на "выполнено"')),
      );
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> _deleteRequest(int id) async {
    try {
      final db = await DatabaseHelper().database;
      await db.delete(
        'repair_requests',
        where: 'id = ?',
        whereArgs: [id],
      );
      await _fetchData(); // Обновляем данные после удаления
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заявка успешно удалена')),
      );
    } catch (e) {
      print('Error deleting request: $e');
    }
  }

  Future<void> _fetchData() async {
    try {
      final repairData = await DatabaseHelper().getRepairRequests();
      final paintingData = await DatabaseHelper().getPaintingRequests();
      if (mounted) {
        setState(() {
          repairRequests = repairData;
          paintingRequests = paintingData;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _sortRepairRequests(String criteria) {
    setState(() {
      repairRequests = List.from(repairRequests)
        ..sort((a, b) {
          int result = 0;
          if (criteria == 'name') {
            result = (a['ownerName'] ?? '').compareTo(b['ownerName'] ?? '');
          } else if (criteria == 'date') {
            result = (a['date'] ?? '').compareTo(b['date'] ?? '');
          }
          return _isRepairSortedAscending ? result : -result;
        });
      _isRepairSortedAscending = !_isRepairSortedAscending;
    });
  }

  void _sortPaintingRequests(String criteria) {
    setState(() {
      paintingRequests = List.from(paintingRequests)
        ..sort((a, b) {
          int result = 0;
          if (criteria == 'name') {
            result = (a['ownerName'] ?? '').compareTo(b['ownerName'] ?? '');
          } else if (criteria == 'date') {
            result = (a['date'] ?? '').compareTo(b['date'] ?? '');
          }
          return _isPaintingSortedAscending ? result : -result;
        });
      _isPaintingSortedAscending = !_isPaintingSortedAscending;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Останавливаем таймер при уничтожении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentDateTime,
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result =
                            await Navigator.pushNamed(context, '/create_request');
                        if (result == true) {
                          _fetchData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Создать заявку',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatisticsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Статистика',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaintingPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Покраска',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Заявки на ремонт',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sort_by_alpha),
                        onPressed: () => _sortRepairRequests('name'),
                        tooltip: 'Сортировать по имени',
                      ),
                      IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () => _sortRepairRequests('date'),
                        tooltip: 'Сортировать по дате',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildTableWithBorder(_buildRepairRequestsTable()),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Заявки на покраску',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sort_by_alpha),
                        onPressed: () => _sortPaintingRequests('name'),
                        tooltip: 'Сортировать по имени',
                      ),
                      IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () => _sortPaintingRequests('date'),
                        tooltip: 'Сортировать по дате',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildTableWithBorder(_buildPaintingRequestsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildTableWithBorder(Widget table) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: table,
    );
  }

  Widget _buildRepairRequestsTable() {
    return repairRequests.isEmpty
        ? const Center(child: Text('Нет данных для отображения заявок на ремонт'))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Имя владельца')),
                DataColumn(label: Text('Телефон')),
                DataColumn(label: Text('Модель')),
                DataColumn(label: Text('Дата')),
                DataColumn(label: Text('Время')),
                DataColumn(label: Text('Статус')),
                DataColumn(label: Text('Действие')),
              ],
              rows: repairRequests.map((request) {
                return DataRow(cells: [
                  DataCell(Text(request['ownerName'] ?? '')),
                  DataCell(Text(request['phoneNumber'] ?? '')),
                  DataCell(Text(request['carModel'] ?? '')),
                  DataCell(Text(request['date'] ?? '')),
                  DataCell(Text(request['time'] ?? '')),
                  DataCell(Text(request['status'] ?? 'в работе')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditRequestPage(request: request),
                              ),
                            );
                            if (result == true) {
                              _fetchData();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: request['status'] == 'выполнено'
                              ? null
                              : () => _markAsCompleted(request['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRequest(request['id']),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
  }

  Widget _buildPaintingRequestsTable() {
    return paintingRequests.isEmpty
        ? const Center(child: Text('Нет данных для отображения заявок на покраску'))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Имя владельца')),
                DataColumn(label: Text('Телефон')),
                DataColumn(label: Text('Модель')),
                DataColumn(label: Text('Цвет')),
                DataColumn(label: Text('Дата')),
                DataColumn(label: Text('Статус')),
                DataColumn(label: Text('Действие')),
              ],
              rows: paintingRequests.map((request) {
                return DataRow(cells: [
                  DataCell(Text(request['ownerName'] ?? '')),
                  DataCell(Text(request['phoneNumber'] ?? '')),
                  DataCell(Text(request['carModel'] ?? '')),
                  DataCell(Text(request['color'] ?? '')),
                  DataCell(Text(request['date'] ?? '')),
                  DataCell(Text(request['status'] ?? 'в работе')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPaintingPage(paintingRequest: request),
                              ),
                            );
                            if (result == true) {
                              _fetchData();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: request['status'] == 'выполнено'
                              ? null
                              : () async {
                                  await _markPaintingAsCompleted(request['id']);
                                },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DatabaseHelper()
                                .deletePaintingRequest(request['id']);
                            _fetchData();
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
  }

  Future<void> _markPaintingAsCompleted(int id) async {
    try {
      final db = await DatabaseHelper().database;
      await db.update(
        'painting_requests',
        {'status': 'выполнено'},
        where: 'id = ?',
        whereArgs: [id],
      );
      await _fetchData(); // Обновляем данные после изменения статуса
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Статус заявки на покраску обновлен на "выполнено"')),
      );
    } catch (e) {
      print('Error updating painting status: $e');
    }
  }
}
