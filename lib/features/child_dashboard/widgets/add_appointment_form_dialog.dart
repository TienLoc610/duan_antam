import 'package:flutter/material.dart';

class AddAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddAppointmentScreen({super.key, this.initialData});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  late TextEditingController _titleController;
  late TextEditingController _locController;
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _locController = TextEditingController(text: widget.initialData?['info']?.replaceAll('Tại: ', '') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialData == null ? 'Hẹn lịch khám' : 'Sửa lịch khám'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Nội dung khám')),
            TextField(controller: _locController, decoration: const InputDecoration(labelText: 'Địa điểm/Bệnh viện')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                      if (d != null) setState(() => _date = d);
                    },
                    child: Text(_date == null ? "Chọn Ngày" : "${_date!.day}/${_date!.month}"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) setState(() => _time = t);
                    },
                    child: Text(_time == null ? "Giờ" : _time!.format(context)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _date != null && _time != null) {
              Navigator.pop(context, {
                'type': 'appointment',
                'title': _titleController.text,
                'info': 'Tại: ${_locController.text}',
                'date': '${_date!.day}/${_date!.month}/${_date!.year}',
                'time': _time!.format(context),
              });
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}