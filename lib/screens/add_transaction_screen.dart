import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:uuid/uuid.dart'; // Vamos gerar IDs únicos

class AddTransactionScreen extends StatefulWidget {
  final Function(Transaction) onAddTransaction;

  const AddTransactionScreen({super.key, required this.onAddTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = true;
  DateTime _selectedDate = DateTime.now();

  void _submitForm() {
    if (_descriptionController.text.isEmpty || _amountController.text.isEmpty) {
      return; // Se algum campo estiver vazio, não faz nada
    }

    final newTx = Transaction(
      id: const Uuid().v4(), // Gerando um ID único
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      isIncome: _isIncome,
    );

    widget.onAddTransaction(newTx);
    Navigator.of(context).pop(); // Fecha a tela
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: [
                const Text('Entrada'),
                Switch(
                  value: _isIncome,
                  onChanged: (val) {
                    setState(() {
                      _isIncome = val;
                    });
                  },
                ),
                const Text('Saída'),
              ],
            ),
            Row(
              children: [
                Text('Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
