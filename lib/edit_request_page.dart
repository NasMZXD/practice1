import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditRequestPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const EditRequestPage({super.key, required this.request});

  @override
  _EditRequestPageState createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late TextEditingController ownerNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController carModelController;
  late TextEditingController issueDescriptionController;

  @override
  void initState() {
    super.initState();
    ownerNameController =
        TextEditingController(text: widget.request['ownerName']);
    phoneNumberController =
        TextEditingController(text: widget.request['phoneNumber']);
    carModelController = TextEditingController(text: widget.request['carModel']);
    issueDescriptionController =
        TextEditingController(text: widget.request['issueDescription']);
  }

  Future<void> _saveChanges() async {
    Map<String, dynamic> updatedRequest = {
      'ownerName': ownerNameController.text,
      'phoneNumber': phoneNumberController.text,
      'carModel': carModelController.text,
      'issueDescription': issueDescriptionController.text,
    };

    await DatabaseHelper().updateRequest(widget.request['id'], updatedRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заявка успешно обновлена')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
                controller: issueDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание проблемы',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
