##### \# 🏠 TroSmart - Smart Hostel Management System



Dự án TroSmart được tổ chức theo cấu trúc phân lớp (Layer-based Architecture), chia tách minh bạch giữa Giao diện (View), Thành phần (Widget), Dữ liệu (Model) và Logic xử lý. Đặc biệt, hệ thống được thiết kế để hỗ trợ đa vai trò (User/Admin).



\## 📂 Cấu trúc thư mục chi tiết



```text

lib/

├── logic/ # Xử lý logic nghiệp vụ (Controllers, BLoC, Providers)
├── models/ # Định nghĩa các đối tượng dữ liệu (DTOs, Entities)
├── shared/ # Cấu hình dùng chung cho toàn hệ thống
│ ├── app_colors.dart
│ └── app_theme.dart # Quản lý giao diện Light/Dark Mode và màu sắc chủ đạo
├── views/ # LỚP HIỂN THỊ (Màn hình chính)
│ ├── admin/ # Giao diện dành cho Chủ trọ
│ │ ├── add_invoice_screen.dart
│ │ ├── invoice_detail_screen.dart
│ │ ├── utility_management_view.dart
│ │ └── statistics_screen.dart
│ ├── auth/ # Giao diện Đăng nhập / Đăng ký (hiện chưa có file)
│ └── user/ # Giao diện dành cho Khách thuê
│ ├── navigation_screen.dart # Bộ điều hướng Bottom Nav
│ ├── payment_screen.dart # Chi tiết thanh toán hóa đơn
│ ├── stats_screen.dart # Thống kê chi tiêu & lịch sử
│ ├── app_sidebar.dart
│ └── notification_screen.dart
├── widgets/ # THÀNH PHẦN GIAO DIỆN NHỎ (Components)
│ ├── admin/ # Các widget đặc thù cho quản lý (Admin) (hiện chưa có file)
│ ├── common/ # Widget dùng chung (Buttons, Inputs, Dialogs)
│ └── user/ # Widget phục vụ giao diện Khách thuê
│ ├── payment_widgets.dart # Các thẻ bài (Cards) trong trang thanh toán
│ ├── stats_widgets.dart # Biểu đồ và các thẻ tóm tắt thống kê
│ ├── sidebar_item.dart
│ └── notification_tile.dart
└── main.dart # File khởi chạy ứng dụng
