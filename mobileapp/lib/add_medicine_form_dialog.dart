import 'package:flutter/material.dart';

class AddMedicineFormDialog extends StatelessWidget {
  const AddMedicineFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double dialogWidth = constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Container(
            width: dialogWidth,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Color(0x3F000000), blurRadius: 50, offset: Offset(0, 25), spreadRadius: -12),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header
                  Container(
                    width: double.infinity,
                    height: 69.23,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: Border(bottom: BorderSide(width: 1.27, color: Colors.black.withOpacity(0.10))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Thêm lịch uống thuốc',
                          style: TextStyle(
                            color: const Color(0xFF101727),
                            fontSize: 20,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(width: 36, height: 36, child: Icon(Icons.close)),
                        ),
                      ],
                    ),
                  ),
                  // Form Fields Placeholder
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlaceholderField('Tên thuốc', 'VD: Thuốc hạ huyết áp A'),
                        SizedBox(height: 16.0),
                        _buildPlaceholderField('Liều lượng', 'VD: 1 viên'),
                        SizedBox(height: 16.0),
                        _buildPlaceholderTimeSelector('Thời gian uống', 'Chọn các mốc giờ'),
                        SizedBox(height: 16.0),
                        _buildPlaceholderTimeSelector('Tần suất', 'Hàng ngày / Thứ 2, 4, 6'),
                        SizedBox(height: 24.0),
                        _buildModalButtons(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(color: const Color(0xFF354152), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
            Text('*', style: TextStyle(color: const Color(0xFFFA2B36), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
          ],
        ),
        SizedBox(height: 8.0),
        Container(
          height: 42.50,
          decoration: BoxDecoration(
            border: Border.all(width: 1.27, color: const Color(0xFFD0D5DB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: const Color(0x7F0A0A0A), fontSize: 16, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderTimeSelector(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(color: const Color(0xFF354152), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
            Text('*', style: TextStyle(color: const Color(0xFFFA2B36), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
          ],
        ),
        SizedBox(height: 8.0),
        Container(
          height: 42.50,
          decoration: BoxDecoration(
            border: Border.all(width: 1.27, color: const Color(0xFFD0D5DB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(placeholder, style: TextStyle(color: const Color(0x7F0A0A0A)))),
        ),
      ],
    );
  }

  Widget _buildModalButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 50.51,
              decoration: BoxDecoration(
                border: Border.all(width: 1.27, color: const Color(0xFFD0D5DB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('Hủy', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF354152), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Container(
            height: 50.51,
            decoration: BoxDecoration(
              color: const Color(0xFF155DFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('Thêm thuốc', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
            ),
          ),
        ),
      ],
    );
  }
}