# Demo quản lý chi tiêu

Ứng dụng Flutter mẫu quản lý các khoản chi theo mô hình MVVM:

- **Model**: `Expense` và danh sách danh mục có sẵn.
- **Database**: SQLite lưu khoản chi; tự thêm một vài dữ liệu mẫu ở lần chạy đầu.
- **ViewModel**: Riverpod Generator (`@riverpod`) quản lý tải, thêm, sửa, xóa dữ liệu và đơn vị tiền.
- **View**: màn hình danh sách, màn hình chỉnh sửa riêng, biểu mẫu thêm và cài đặt tiền tệ.
- **Lưu tùy chọn**: SharedPreferences lưu VND hoặc USD qua các lần mở ứng dụng.

## Hướng dẫn các bước thực hiện

| Bước | Việc cần làm | Thành phần |
|---|---|---|
| 1 | Khởi tạo Flutter project và thêm Riverpod Generator, SQLite, SharedPreferences, intl | `pubspec.yaml` |
| 2 | Tạo model khoản chi gồm tên, số tiền, danh mục và ngày; định nghĩa danh sách danh mục | `lib/models/expense.dart` |
| 3 | Tạo bảng SQLite, thêm dữ liệu mẫu và các hàm đọc/thêm/sửa/xóa | `lib/data/database_helper.dart` |
| 4 | Tạo ViewModel với `@riverpod` để quản lý danh sách và CRUD | `lib/viewmodels/expense_view_model.dart` |
| 5 | Tạo ViewModel đọc/lưu loại tiền bằng SharedPreferences | `lib/viewmodels/expense_view_model.dart` |
| 6 | Dựng màn hình danh sách với tiêu đề, cài đặt, ngày, danh mục, số tiền và nút sửa | `lib/screens/home_screen.dart` |
| 7 | Tạo màn hình chỉnh sửa riêng có các trường dữ liệu cùng nút Hủy/Lưu ở cuối | `lib/screens/edit_expense_screen.dart` |
| 8 | Cấu hình cài đặt tiền tệ có lựa chọn tạm thời và nút Hủy/Lưu | `lib/screens/home_screen.dart` |
| 9 | Bọc ứng dụng bằng `ProviderScope` và cấu hình giao diện | `lib/main.dart` |
| 10 | Lấy dependencies, sinh provider, phân tích mã và khởi động demo | `flutter pub get`, `dart run build_runner build`, `flutter analyze`, `flutter run` |

## Chạy demo

```shell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

Chọn biểu tượng bánh răng để đổi VND/USD; nhấn **Lưu** để ghi lựa chọn vào thiết
bị hoặc **Hủy** để bỏ thay đổi. Nút **Thêm khoản chi** mở biểu mẫu tạo dữ liệu;
biểu tượng bút điều hướng đến màn hình **Chỉnh sửa khoản chi**, với các nút
**Hủy** và **Lưu** ở cuối trang.
