import 'package:flutter/material.dart';

class AddMedicineFormDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddMedicineFormDialog({super.key, this.initialData});

  @override
  _AddMedicineFormDialogState createState() => _AddMedicineFormDialogState();
}

class _AddMedicineFormDialogState extends State<AddMedicineFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  TimeOfDay? _time;
  String _frequency = 'Hằng ngày';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _doseController = TextEditingController(text: widget.initialData?['info']?.replaceAll('Liều: ', '') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialData == null ? 'Thêm lịch thuốc' : 'Sửa lịch thuốc'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Tên thuốc')),
          TextField(controller: _doseController, decoration: const InputDecoration(labelText: 'Liều lượng (VD: 1 viên)')),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_time == null ? "Chọn giờ uống" : "Giờ: ${_time!.format(context)}"),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (t != null) setState(() => _time = t);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty && _time != null) {
              Navigator.pop(context, {
                'type': 'medication',
                'title': _nameController.text,
                'info': 'Liều: ${_doseController.text} | $_frequency',
                'time': _time!.format(context),
              });
            }
          },
          child: const Text('Lưu'),
        )
      ],
    );
  }
}