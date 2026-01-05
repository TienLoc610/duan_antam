Dự án "An Tâm" – Hệ thống Hỗ trợ Chăm sóc Người cao tuổi
An Tâm là ứng dụng di động được xây dựng bằng Flutter, giúp kết nối con cái với cha mẹ lớn tuổi. Ứng dụng giải quyết nỗi lo lắng của người con khi ở xa và giúp người già sử dụng công nghệ dễ dàng hơn thông qua giao diện tối giản.

🌟 Tính năng chính
1. Phân hệ "Cha Mẹ" (Elder App)
Giao diện tối giản: Nút bấm khổ lớn, độ tương phản cao, dễ nhìn.

SOS Khẩn cấp: Gửi cảnh báo ngay lập tức cho con cái.

Check-in Thuốc: Xác nhận đã uống thuốc chỉ với 1 chạm.

Gọi nhanh: Gọi điện cho con cái không cần quay số.

Đồng hồ: Hiển thị giờ và ngày tháng to, rõ ràng theo thời gian thực.

2. Phân hệ "Con" (Carer App)
Dashboard: Theo dõi trạng thái của cha mẹ (đã uống thuốc chưa, có gọi SOS không).

Quản lý lịch: Thêm lịch uống thuốc, lịch khám bệnh từ xa.

Thông báo: Nhận thông báo đẩy khi có sự kiện khẩn cấp.

Album gia đình: Chia sẻ ảnh để cha mẹ xem cho đỡ buồn.

🛠 Yêu cầu hệ thống (Prerequisites)
Trước khi chạy dự án, hãy đảm bảo máy tính của bạn đã cài đặt:

Flutter SDK: Phiên bản mới nhất (Kiểm tra bằng flutter --version).

Visual Studio Code hoặc Android Studio.

Git (để quản lý mã nguồn).

Thiết bị chạy thử: Máy ảo Android (Emulator) hoặc điện thoại Android thật.

🚀 Hướng dẫn Cài đặt & Chạy (Từng bước)
Bước 1: Tải mã nguồn
Mở Terminal (hoặc CMD/Git Bash) và chạy lệnh:

Bash

git clone https://github.com/TienLoc610/duan_antam.git
cd duan_antam
Bước 2: Cài đặt thư viện
Tải các gói thư viện cần thiết (Firebase, Url Launcher, Intl...):

Bash

flutter pub get
Bước 3: Cấu hình Firebase (Quan trọng)
Để ứng dụng hoạt động đầy đủ tính năng, bạn cần kết nối với Firebase:

Truy cập Firebase Console.

Tạo dự án mới tên An Tam.

Vào mục Project Settings, thêm ứng dụng Android.

Package name: Tìm trong file android/app/build.gradle (thường là com.example.duan_antam).

Tải file google-services.json về máy.

Di chuyển file đó vào thư mục: android/app/ trong dự án của bạn.

Trên Firebase Console, vào mục Build > Firestore Database -> Create Database -> Chọn Start in Test Mode (để không bị chặn quyền truy cập khi test).

Bước 4: Chạy ứng dụng
Kết nối điện thoại hoặc mở máy ảo, sau đó chạy lệnh:

Bash

flutter run
📂 Cấu trúc Thư mục
Dự án được tổ chức theo cấu trúc rõ ràng để dễ bảo trì:

Plaintext

lib/
├── main.dart                   # Điểm khởi chạy, định nghĩa Routes
├── screens/                    # Các màn hình chính
│   ├── onboarding_screen.dart  # Màn hình Chào mừng (Chọn vai trò)
│   ├── auth_screen.dart        # Đăng nhập / Đăng ký
│   ├── an_tam_con_dashboard.dart # Màn hình chính của Con
│   └── parent_home_screen.dart   # Màn hình chính của Cha Mẹ
├── widgets/                    # Các Widget tái sử dụng & Dialog
│   ├── big_button.dart         # Nút bấm lớn (cho màn hình Cha Mẹ)
│   ├── feature_list_widget.dart # Danh sách tính năng (cho màn hình Chào mừng)
│   ├── add_medicine_form.dart  # Form thêm thuốc
│   └── add_appointment_form.dart # Form thêm lịch hẹn
└── services/                   # Xử lý Logic & Backend
    └── firebase_service.dart   # Kết nối Firestore