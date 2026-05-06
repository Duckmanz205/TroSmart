##### \# 🏠 TroSmart - Smart Hostel Management System



Dự án TroSmart được tổ chức theo cấu trúc phân lớp (Layer-based Architecture), chia tách minh bạch giữa Giao diện (View), Thành phần (Widget), Dữ liệu (Model) và Logic xử lý. Đặc biệt, hệ thống được thiết kế để hỗ trợ đa vai trò (User/Admin).



\## 📂 Cấu trúc thư mục chi tiết



```text

lib/
├── logic/              # Xử lý Logic nghiệp vụ (Controllers, BLoC, Providers) - Hiện tại trống, có thể thêm các file xử lý trạng thái, API calls, hoặc business logic cho admin/user
├── models/             # Định nghĩa các đối tượng dữ liệu (DTOs, Entities)
│   ├── admin/          # Models cho admin (chủ trọ) - Hiện tại trống, có thể thêm các model như Invoice, Utility, Room
│   └── user/           # Models cho user (khách thuê)
│       └── app_pages.dart # Định nghĩa các trang app và cấu trúc điều hướng
├── shared/             # Cấu hình dùng chung cho toàn hệ thống
│   ├── app_colors.dart  # Quản lý màu sắc chủ đạo của app
│   └── app_theme.dart   # Quản lý giao diện Light/Dark Mode và theme tổng thể
├── views/              # LỚP HIỂN THỊ (Màn hình chính)
│   ├── admin/          # Giao diện dành cho Chủ trọ
│   │   ├── add_invoice_screen.dart     # Màn hình thêm hóa đơn
│   │   ├── invoice_detail_screen.dart  # Màn hình chi tiết hóa đơn
│   │   ├── utility_management_view.dart # Màn hình quản lý tiện ích (điện, nước, v.v.)
│   │   └── statistics_screen.dart      # Màn hình thống kê
│   ├── auth/           # Giao diện Đăng nhập / Đăng ký - Hiện tại trống, có thể thêm login_screen.dart, register_screen.dart
│   └── user/           # Giao diện dành cho Khách thuê
│       ├── navigation_screen.dart # Bộ điều hướng Bottom Nav (màn hình chính với tab)
│       ├── payment_screen.dart    # Chi tiết thanh toán hóa đơn
│       ├── stats_screen.dart      # Thống kê chi tiêu & lịch sử
│       ├── app_sidebar.dart       # Thanh sidebar cho điều hướng phụ
│       └── notification_screen.dart # Màn hình thông báo
├── widgets/            # THÀNH PHẦN GIAO DIỆN NHỎ (Components)
│   ├── admin/          # Các widget đặc thù cho quản lý (Admin)
│   │   ├── invoice_header.dart         # Header cho hóa đơn
│   │   ├── billing_info_card.dart      # Thẻ thông tin thanh toán
│   │   ├── invoice_summary_header.dart # Header tóm tắt hóa đơn
│   │   ├── invoice_detail_row.dart     # Hàng chi tiết hóa đơn
│   │   ├── utility_summary_card.dart   # Thẻ tóm tắt tiện ích
│   │   ├── utility_index_field.dart    # Trường nhập chỉ số tiện ích
│   │   └── room_utility_entry_card.dart # Thẻ nhập tiện ích cho phòng
│   ├── common/         # Widget dùng chung (Buttons, Inputs, Dialogs)
│   │   ├── custom_bottom_navigation.dart # Điều hướng bottom tùy chỉnh
│   │   └── user_app_bar.dart            # App bar cho user
│   └── user/           # Widget phục vụ giao diện Khách thuê
│       ├── payment_widgets.dart # Các thẻ bài (Cards) trong trang thanh toán
│       ├── stats_widgets.dart   # Biểu đồ và các thẻ tóm tắt thống kê
│       ├── sidebar_item.dart    # Item trong sidebar
│       └── notification_tile.dart # Tile cho thông báo
└── main.dart           # File khởi chạy ứng dụng (chạy TroSmartApp với theme và navigation chính)
