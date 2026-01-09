import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import file main của dự án
import 'package:duan_antam/main.dart';

void main() {
  testWidgets('Kiểm tra màn hình Chào mừng (Onboarding) hiển thị đúng', (WidgetTester tester) async {
    // 1. Khởi chạy ứng dụng (Sử dụng AnTamApp thay vì MyApp)
    await tester.pumpWidget(const AnTamApp());

    // 2. Chờ cho các animation hoặc render hoàn tất
    await tester.pumpAndSettle();

    // 3. Kiểm tra xem các văn bản quan trọng có xuất hiện không
    // Tìm tiêu đề chính
    expect(find.text('Hệ thống An Tâm'), findsOneWidget);

    // Tìm thẻ chọn vai trò "Con"
    expect(find.text('An Tâm - Con'), findsOneWidget);

    // Tìm thẻ chọn vai trò "Cha Mẹ"
    expect(find.text('An Tâm - Cha Mẹ'), findsOneWidget);

    // 4. Kiểm tra các thành phần cũ của Counter App KHÔNG TỒN TẠI
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}