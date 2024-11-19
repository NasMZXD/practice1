import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditPaintingPage extends StatefulWidget {
  final Map<String, dynamic> paintingRequest;

  const EditPaintingPage({super.key, required this.paintingRequest});

  @override
  _EditPaintingPageState createState() => _EditPaintingPageState();
}

class _EditPaintingPageState extends State<EditPaintingPage> {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    carModelController.text = widget.paintingRequest['carModel'] ?? '';
    colorController.text = widget.paintingRequest['color'] ?? '';
    ownerNameController.text = widget.paintingRequest['ownerName'] ?? '';
    phoneNumberController.text = widget.paintingRequest['phoneNumber'] ?? '';
    selectedDate = DateTime.tryParse(widget.paintingRequest['date'] ?? '');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

  Future<void> _saveChanges() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите дату')),
      );
      return;
    }

    String formattedDate =
        "${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}";

    Map<String, dynamic> updatedRequest = {
      'ownerName': ownerNameController.text,
      'phoneNumber': phoneNumberController.text,
      'carModel': carModelController.text,
      'color': colorController.text,
      'date': formattedDate,
    };

    // Используем метод для обновления в таблице `painting_requests`
    await DatabaseHelper().updatePaintingRequest(
      widget.paintingRequest['id'],
      updatedRequest,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заявка успешно обновлена')),
    );

    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate != null
        ? "${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}"
        : 'Выберите дату';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование заявки'),
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
                  labelText: 'Цвет',
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
                  onPressed: _saveChanges,
                  child: const Text('Сохранить изменения'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
