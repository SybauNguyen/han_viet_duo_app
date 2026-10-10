# Hán-Việt Duo — Flutter MVP

Ứng dụng học chữ Hán theo âm Hán-Việt, xây dựng từ kế hoạch/mã nguồn bạn gửi. Bản này được ghép thành một project Flutter độc lập để dễ chạy hơn, thay vì phải tự tạo hàng chục file từ các đoạn code rời.

## Chức năng hiện có

Phiên bản mã nguồn: **1.1.0**. Bộ dữ liệu mới tránh tạo bản ghi trùng cho 愛, 日 và 月; bảy chữ bổ sung cuối (門、車、金、石、田、竹、米) giúp tổng số đạt 125 chữ duy nhất.

- Lộ trình gồm 25 bài học, mỗi bài có 5 chữ. Bộ dữ liệu gồm 125 Hán tự duy nhất, với các nhóm số đếm, phương hướng, thiên nhiên, gia đình, cơ thể, động vật, màu sắc, hành động, cảm xúc, thời gian và đồ vật.
- Bài học chia cố định thành 3 phần, không xáo trộn thứ tự các phần: (1) nhận diện bộ thủ, (2) học âm và chữ, (3) kiểm tra trí nhớ bằng cách tự gõ âm Hán-Việt hoặc nghĩa. Câu hỏi được xáo trộn bên trong từng phần. Bài chứa chữ 學 có thêm câu điền chữ ghép trong phần 2.
- Dạng câu hỏi điền chữ còn thiếu với chức năng chạm chữ để xem âm Hán-Việt và nghĩa.
- Phản hồi đúng/sai, thanh tiến độ, tim, XP và đá quý. Khi hết tim, ứng dụng chặn bài học để người dùng nạp đầy 5 tim bằng 350 đá quý, nhận +1 tim qua quảng cáo giả lập hoặc thoát bài học.
- Mở khóa bài kế tiếp khi hoàn thành bài trước.
- Ôn tập các chữ có mức thuần thục thấp.
- Từ điển tìm theo chữ Hán, âm Hán-Việt, nghĩa, bộ thủ hoặc từ gợi ý; đã bổ sung nhóm số đếm, phương hướng, thiên nhiên, gia đình, bộ phận cơ thể, động từ và tính từ cơ bản.
- Thẻ chi tiết có âm đọc, nghĩa, bộ thủ, cấu tạo và từ ghép gợi ý.
- Hồ sơ, cấp độ và một số thành tựu.
- Lưu XP, tim, đá quý, chuỗi ngày, tiến độ bài học và mức thuần thục trên thiết bị bằng `shared_preferences`. Lần nâng cấp này tăng số dư đá quý ban đầu lên tối thiểu 500 một lần để có thể dùng thử luồng nạp tim mới.
- Giao diện tiếng Việt, Material 3, tông xanh lá.

## Cách chạy trên Windows

### 1. Cài Flutter

Cài Flutter SDK và Android Studio (nếu chạy trên máy ảo Android). Sau khi cài, mở **PowerShell** hoặc **Command Prompt** và kiểm tra:

```powershell
flutter --version
flutter doctor
```

### 2. Giải nén project

Giải nén `han_viet_duo_app.zip`, sau đó mở terminal tại thư mục `han_viet_duo_app`.

### 3. Tạo các thư mục nền tảng lần đầu

Project trong gói tập trung vào mã nguồn `lib/` và `pubspec.yaml`. Nếu chưa có thư mục `android/`, `web/` hoặc `windows/`, chạy file:

```text
setup_and_run.bat
```

Script sẽ tạo cấu trúc nền tảng Flutter còn thiếu, khôi phục mã nguồn ứng dụng và chạy `flutter pub get`, sau đó gọi `flutter run`.

Nếu muốn tự thao tác, có thể tạo nền tảng trước rồi tải thư viện:

```powershell
flutter create --platforms=android,web,windows --project-name=han_viet_duo .
flutter pub get
flutter run
```

**Lưu ý:** Nếu chạy lệnh `flutter create` thủ công trong thư mục đã có mã nguồn, hãy sao lưu `lib/` trước. File `setup_and_run.bat` tự sao lưu và khôi phục `lib/` cùng `pubspec.yaml`.

### 4. Chạy trên thiết bị cụ thể

```powershell
flutter devices
flutter run -d chrome
```

Hoặc chọn Android Emulator/điện thoại Android đang kết nối trong danh sách thiết bị mà Flutter hiển thị.

## Cấu trúc chính

```text
han_viet_duo_app/
├── lib/
│   ├── main.dart
│   ├── data/
│   │   ├── han_character.dart
│   │   ├── question.dart
│   │   └── han_seed_data.dart
│   ├── state/
│   │   └── app_state.dart
│   └── widgets/
│       └── interactive_sentence.dart
├── test/
│   └── han_data_test.dart
├── pubspec.yaml
├── setup_and_run.bat
└── README.md
```

## Phạm vi và lưu ý

Đây là bản MVP để chạy thử và phát triển tiếp, không phải bản phát hành cửa hàng ứng dụng. Dữ liệu chữ hiện tại là tập dữ liệu mẫu ban đầu; phần từ ghép và giải thích cấu tạo cần được biên tập/kiểm chứng thêm trước khi mở rộng. Phiên bản này dùng lưu trữ cục bộ bằng `shared_preferences` để đơn giản hóa việc khởi chạy đa nền tảng; có thể chuyển sang SQLite khi cần tìm kiếm và quản lý dữ liệu lớn hơn.
