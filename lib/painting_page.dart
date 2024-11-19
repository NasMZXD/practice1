import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class PaintingPage extends StatefulWidget {
  const PaintingPage({super.key});

  @override
  _PaintingPageState createState() => _PaintingPageState();
}

class _PaintingPageState extends State<PaintingPage> {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ru', ''), // Устанавливаем русский язык
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _savePaintingRequest() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите дату покраски')),
      );
      return;
    }

    String formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate!);

    Map<String, dynamic> paintingRequest = {
      'ownerName': ownerNameController.text,
      'phoneNumber': phoneNumberController.text,
      'carModel': carModelController.text,
      'color': colorController.text,
      'date': formattedDate,
      'status': 'в работе', // Устанавливаем статус заявки
    };

    // Сохранение данных в таблицу painting_requests
    await DatabaseHelper().insertPaintingRequest(paintingRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заявка на покраску успешно сохранена')),
    );

    // Очистка полей после сохранения
    ownerNameController.clear();
    phoneNumberController.clear();
    carModelController.clear();
    colorController.clear();
    setState(() {
      selectedDate = null;
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate != null
        ? DateFormat('dd.MM.yyyy').format(selectedDate!)
        : 'Выберите дату';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заявки на покраску'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя владельца',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: carModelController,
                decoration: const InputDecoration(
                  labelText: 'Модель автомобиля',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  labelText: 'Желаемый цвет покраски',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _selectDate(context),
                child: Text(formattedDate),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _savePaintingRequest,
                  child: const Text('Оформить заявку'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
