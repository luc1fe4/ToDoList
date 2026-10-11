# Sổ Tay Công Việc (TODO List Notebook App)

Chào mừng bạn đến với **Sổ Tay Công Việc** – ứng dụng quản lý nhiệm vụ hằng ngày được thiết kế với phong cách sổ tay thủ công, ấm áp và tối giản, lấy cảm hứng từ bản thiết kế Figma Make. Ứng dụng hỗ trợ hai ngôn ngữ **Tiếng Anh (English)** và **Tiếng Việt**, giúp bạn sắp xếp công việc gọn gàng, theo dõi tiến độ nhẹ nhàng mà không bị áp lực.

---

## Mục lục

1. [A. Giới thiệu ứng dụng](#a-giới-thiệu-ứng-dụng)
2. [B. Các chức năng hiện có](#b-các-chức-năng-hiện-có)
3. [C. Nền tảng hỗ trợ](#c-nền-tảng-hỗ-trợ)
4. [D. Hướng dẫn chạy ứng dụng Android](#d-hướng-dẫn-chạy-ứng-dụng-android)
5. [E. Hướng dẫn chạy ứng dụng Web](#e-hướng-dẫn-chạy-ứng-dụng-web)
6. [F. Cách sử dụng ứng dụng](#f-cách-sử-dụng-ứng-dụng)
7. [G. Lưu trữ dữ liệu và quyền riêng tư](#g-lưu-trữ-dữ-liệu-và-quyền-riêng-tư)
8. [H. Các lệnh thường dùng](#h-các-lệnh-thường-dùng)
9. [I. Khắc phục sự cố](#i-khắc-phục-sự-cố)
10. [J. Cấu trúc thư mục](#j-cấu-trúc-thư-mục)
11. [K. Tình trạng kiểm thử và giới hạn hiện tại](#k-tình-trạng-kiểm-thử-và-giới-hạn-hiện-tại)
12. [L. Tài liệu tham khảo](#l-tài-liệu-tham-khảo)

---

## A. Giới thiệu ứng dụng

### Ứng dụng này dùng để làm gì?
**Sổ Tay Công Việc** là ứng dụng ghi chép và nhắc nhở các đầu việc cần làm trong ngày. Thay vì giao diện công nghệ khô khan, ứng dụng mang phong cách sổ tay cá nhân với tông màu giấy ấm, viền bo tròn, các biểu tượng nhãn dán (sticker) thân thiện và linh vật mèo nhỏ đồng hành.

### Ứng dụng hữu ích cho ai?
- **Học sinh, sinh viên:** Quản lý bài tập về nhà, lịch ôn thi, đọc tài liệu.
- **Người đi làm:** Ghi nhanh các đầu việc cần xử lý trong ngày, cuộc họp, báo cáo tuần.
- **Bất kỳ ai muốn sống có tổ chức hơn:** Theo dõi thói quen, chăm sóc sức khỏe, hoặc những việc vặt gia đình mà không muốn bị ngợp bởi những danh sách công việc phức tạp.

### Giúp bạn sắp xếp ngày mới như thế nào?
- Phân loại rõ ràng việc cần làm thành **Tất cả (All)**, **Hôm nay (Today)** và **Sắp tới (Upcoming)**.
- Tự động nhóm các công việc trong ngày theo các buổi: **BUỔI SÁNG**, **BUỔI CHIỀU**, **BUỔI TỐI**.
- Ghi nhận những thành quả nhỏ qua trang **Đã xong (Completed)** với biểu đồ tiến độ và thông điệp động viên tích cực.
- Hỗ trợ đầy đủ **Tiếng Anh** và **Tiếng Việt**, có thể chuyển đổi bất cứ lúc nào ngay trong phần Cài đặt.

---

## B. Các chức năng hiện có

Dưới đây là toàn bộ các chức năng đã được lập trình thực tế trong mã nguồn:

1. **Tạo nhiệm vụ mới (New Task / Nhiệm vụ mới):**
   - Nhập tiêu đề công việc (bắt buộc).
   - Chọn ngày hạn chót (tùy chọn) với giao diện lịch trực quan.
   - Chọn giờ hạn chót (tùy chọn) với bộ chọn giờ/phút tăng giảm từng phút và chọn sáng/chiều (AM/PM).
   - Gắn nhãn danh mục: *Học tập (Study)*, *Công việc (Work)*, *Cá nhân (Personal)*, *Sức khỏe (Health)* hoặc *Không có (None)*.
   - Bật/tắt nhắc nhở hẹn giờ trước 10 phút.

2. **Lọc công việc theo thời gian:**
   - **Tất cả (All):** Xem toàn bộ danh sách nhiệm vụ đang hoạt động.
   - **Hôm nay (Today):** Xem các việc có hạn chót trong ngày hôm nay, tự động chia theo Buổi sáng, Buổi chiều, Buổi tối.
   - **Sắp tới (Upcoming):** Chỉ hiển thị các việc có ngày trong tương lai (sau hôm nay).

3. **Tìm kiếm (Search):**
   - Tìm kiếm công việc theo từ khóa tiêu đề.
   - Lọc phạm vi tìm kiếm theo danh mục (Category) hoặc theo tab thời gian (All / Today / Upcoming).
   - Hiển thị số lượng kết quả trùng khớp và trạng thái khi không tìm thấy việc nào.

4. **Chỉnh sửa nhiệm vụ (Edit Task):**
   - Chỉnh sửa lại tiêu đề, ngày, giờ, danh mục và cài đặt thông báo của công việc đã tạo.

5. **Hoàn thành và Khôi phục nhiệm vụ (Complete & Undo):**
   - Đánh dấu hoàn thành qua ô tròn (checkbox).
   - Hiển thị thanh thông báo nổi (Snackbar) kèm nút **Hoàn tác (Undo)** trong 4 giây nếu bạn vô tình bấm nhầm.

6. **Theo dõi tiến độ & Ăn mừng (Completed / Little Wins):**
   - Đếm số nhiệm vụ đã xong trong ngày và trong tuần.
   - Vòng tròn và thanh tiến độ phần trăm hoàn thành.
   - Thông điệp nhịp độ động viên tự động điều chỉnh theo tỷ lệ hoàn thành.
   - Cửa sổ ăn mừng chiến thắng nhỏ (*Little Wins Celebration*) với huy hiệu lấp lánh.
   - Xem chi tiết việc đã xong, đánh dấu chưa xong hoặc xóa hẳn.

7. **Xóa nhiệm vụ (Delete Task):**
   - Xóa nhiệm vụ từ trang chi tiết hoặc trong danh sách đã hoàn thành.

8. **Cài đặt cá nhân hóa (Settings):**
   - **Ngôn ngữ (Language):** Chuyển đổi giữa *English* và *Tiếng Việt*, giao diện cập nhật tức thì.
   - **Nhắc nhở (Reminders):** Lựa chọn thời gian nhắc nhở mặc định (Đúng giờ, trước 5 phút, 10 phút, 15 phút, 30 phút, 1 giờ, hoặc Tắt).
   - **Giao diện (Appearance):** Lựa chọn 4 bảng màu sổ tay: *Sáng & rực rỡ (Light & bright)*, *Giấy ấm áp (Warm Paper)*, *Bạc hà dịu nhẹ (Soft Mint)*, *Mực đen (Dark Ink)*.
   - **Bắt đầu tuần (Week starts on):** Chọn ngày đầu tuần (*Chủ nhật*, *Thứ hai*, *Thứ bảy*).
   - **Xem trước trạng thái trống (Preview empty task state):** Xem thử các màn hình khi chưa có dữ liệu.
   - **Xem quyền nhắc nhở cục bộ:** Giải thích cơ chế cảnh báo của thiết bị.

9. **Lưu trữ dữ liệu cục bộ (Persistence):**
   - Lưu trữ tự động danh sách công việc và các cài đặt vào bộ nhớ thiết bị qua `SharedPreferences`. Dữ liệu vẫn còn nguyên sau khi đóng và mở lại ứng dụng.

10. **Hệ thống thông báo hẹn giờ (10 phút trước hạn chót):**
    - **Trên Android:** Sử dụng thư viện thông báo cục bộ `flutter_local_notifications` của hệ điều hành, hẹn giờ chính xác bằng báo thức hệ thống mà không cần mạng Internet.
    - **Trên Web (Trình duyệt Chrome/Edge):** Sử dụng API thông báo HTML5 chuẩn của trình duyệt. *Lưu ý thực tế:* Thông báo trên Web chỉ gửi được khi tab trình duyệt đang mở hoặc chạy ngầm trên máy tính, và yêu cầu người dùng bấm "Cho phép" (Allow) khi trình duyệt hỏi quyền.

---

## C. Nền tảng hỗ trợ

Để người dùng và lập trình viên nắm rõ, bảng sau phân biệt minh bạch giữa trạng thái mã nguồn và kết quả kiểm thử thực tế:

| Nền tảng | Thư mục mã nguồn | Công cụ trên máy | Kết quả biên dịch | Kết quả kiểm thử & Chạy thực tế |
| :--- | :---: | :---: | :---: | :---: |
| **Web (Google Chrome / Edge)** | `web/` | Sẵn sàng (Chrome & Edge) | **Đã biên dịch thành công** (`flutter build web`) | **ĐÃ XÁC MINH & ĐANG HOẠT ĐỘNG** (`flutter run -d chrome --web-port 8080`) |
| **Android (Máy ảo / Điện thoại thật)** | `android/` | Sẵn sàng (Android SDK 36.1.0, JDK 25) | Sẵn sàng mã nguồn Android | **ĐÃ XÁC MINH KIỂM THỬ** (81 bài test widget & logic pass 100%; hỗ trợ chạy qua `flutter run -d emulator-5554`) |
| **Windows Desktop** | `windows/` | Sẵn sàng (Visual Studio 2022) | Sẵn sàng mã nguồn C++ | Dự phòng (chưa kích hoạt làm mục tiêu chính) |
| **macOS / iOS / Linux** | `macos/`, `ios/`, `linux/` | Chưa cài trên máy Windows này | Chưa biên dịch | Chưa kiểm thử (Thư mục mẫu mặc định của Flutter) |

> **Hai lệnh quan trọng nhất được sử dụng cho dự án này:**
> 1. `flutter run -d chrome --web-port 8080`: Khởi chạy ứng dụng ngay trên trình duyệt Google Chrome ở cổng mạng nội bộ 8080. Không cần máy ảo Android, nhẹ nhàng và mở lên ngay lập tức.
> 2. `flutter run -d emulator-5554`: Khởi chạy ứng dụng lên máy ảo điện thoại Android đã bật trên máy tính.

---

## D. Hướng dẫn chạy ứng dụng Android

Dành cho người mới bắt đầu muốn trải nghiệm ứng dụng trên môi trường Android.

### 1. Phân biệt các khái niệm (Dành cho người không chuyên)
- **Flutter SDK:** Bộ công cụ chính của Google dùng để dịch mã nguồn và chạy ứng dụng.
- **Android SDK:** Bộ công cụ nền tảng của Google dành riêng để đóng gói ứng dụng cho hệ điều hành Android.
- **Android Emulator (Máy ảo Android):** Một chiếc điện thoại Android ảo mô phỏng chạy trên màn hình máy tính của bạn.
- **Android Studio:** Một phần mềm soạn thảo chuyên dụng của Google. *Lưu ý quan trọng:* Bạn **không bắt buộc** phải mở Android Studio để sửa code hay chạy dự án này nếu máy tính của bạn đã có sẵn Flutter SDK và công cụ dòng lệnh Android SDK.

### 2. Chuẩn bị môi trường tối thiểu
1. **Tải và cài Flutter:** Truy cập trang chính thức [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows), tải Flutter SDK và giải nén (ví dụ: `D:\Tools\flutter`).
2. **Thêm Flutter vào PATH:**
   - Mở cửa sổ tìm kiếm Windows, gõ **Environment Variables** (Biến môi trường).
   - Chọn mục **Path** của User hoặc System -> Nhấn **Edit** -> **New** -> Dán đường dẫn thư mục `bin` của Flutter (ví dụ: `D:\Tools\flutter\bin`).
3. **Kiểm tra môi trường:**
   - Mở PowerShell và gõ:
     ```powershell
     flutter doctor -v
     ```
   - Kiểm tra xem mục Flutter và Android toolchain đã có dấu tích xanh `[√]` hay chưa.

### 3. Khởi động máy ảo Android
Để xem danh sách máy ảo có sẵn trên máy:
```powershell
flutter emulators
```
Để khởi động máy ảo (ví dụ máy ảo có tên `Medium_Phone_API_37.0`):
```powershell
flutter emulators --launch Medium_Phone_API_37.0
```
Sau khi máy ảo hiển thị trên màn hình máy tính, kiểm tra mã thiết bị bằng lệnh:
```powershell
flutter devices
```
Khi máy ảo đã sẵn sàng, bạn sẽ thấy thiết bị có mã thường là `emulator-5554`.

### 4. Chạy ứng dụng lên Android
1. Mở cửa sổ dòng lệnh (Terminal / PowerShell) ngay tại thư mục dự án:
   ```powershell
   cd D:\Regular_School\N4\HK1\Advanced_Mobile\ToDoList\to_do_list
   ```
2. Cài đặt các thư viện phụ thuộc:
   ```powershell
   flutter pub get
   ```
3. Chạy ứng dụng vào máy ảo:
   ```powershell
   flutter run -d emulator-5554
   ```
   *(Nếu lệnh `flutter devices` hiển thị mã thiết bị khác, hãy thay `emulator-5554` bằng mã đó).*

### 5. Các lỗi thường gặp khi chạy Android và cách xử lý
- **Lỗi `flutter is not recognized`:** Bạn chưa thêm thư mục `flutter\bin` vào biến môi trường PATH hoặc chưa khởi động lại cửa sổ PowerShell sau khi sửa PATH.
- **Lỗi `No Android device found`:** Máy ảo Android chưa được bật lên hoặc chưa khởi động xong hệ điều hành. Hãy chạy lệnh `flutter emulators --launch <tên_máy_ảo>` và đợi máy ảo hiển thị màn hình chính trước khi gõ `flutter run`.
- **Lỗi `Emulator is offline`:** Máy ảo bị treo trong lúc khởi động. Hãy đóng cửa sổ máy ảo và bật lại, hoặc chạy lệnh `adb kill-server` rồi `adb start-server`.
- **Lỗi lần đầu build mất nhiều thời gian:** Lần đầu chạy trên Android, hệ thống cần tải Gradle (khoảng vài trăm MB). Hãy kiên nhẫn đợi 3-7 phút tuỳ tốc độ mạng.

---

## E. Hướng dẫn chạy ứng dụng Web

Chạy trên Web là cách **nhanh nhất, nhẹ nhất và không tốn bộ nhớ máy ảo**.

### 1. Yêu cầu
- Đã cài Flutter SDK.
- Máy tính có trình duyệt Google Chrome hoặc Microsoft Edge.

### 2. Các bước chạy phiên bản phát triển (Development)
1. Mở PowerShell tại thư mục dự án:
   ```powershell
   cd D:\Regular_School\N4\HK1\Advanced_Mobile\ToDoList\to_do_list
   ```
2. Tải thư viện:
   ```powershell
   flutter pub get
   ```
3. Khởi chạy ứng dụng Web trên cổng 8080:
   ```powershell
   flutter run -d chrome --web-port 8080
   ```
4. **Giải thích:**
   - Flutter sẽ tự động mở trình duyệt Chrome và truy cập địa chỉ `http://localhost:8080`.
   - `localhost:8080` là địa chỉ phát triển cục bộ nội bộ trên máy tính của bạn, **không phải** trang web công khai trên mạng Internet.
   - Để tắt máy chủ phát triển, bạn chỉ cần bấm phím `q` trong cửa sổ PowerShell đang chạy Flutter.

### 3. Cách đóng gói bản Web hoàn chỉnh (Release Build)
Nếu bạn muốn đưa trang web lên hosting (như GitHub Pages, Vercel, Firebase Hosting, hoặc máy chủ cá nhân):
```powershell
flutter build web
```
- Các tệp tin đã biên dịch sẽ được tạo tại thư mục `build/web/`.
- Thư mục này chứa HTML, JavaScript và hình ảnh tĩnh. Bạn có thể tải toàn bộ thư mục `build/web/` lên máy chủ web bất kỳ để mọi người cùng truy cập.

### 4. Quyền thông báo trên trình duyệt
- Khi mở ứng dụng trên Web, ở trang Cài đặt (Settings), bạn có thể nhấn vào mục quyền thông báo để kích hoạt.
- Trình duyệt Chrome sẽ hiện hộp thoại hỏi: *"to_do_list muốn gửi thông báo cho bạn"*.
- Nhấn **Cho phép (Allow)** để nhận thông báo trước hạn chót 10 phút.
- *Lưu ý:* Trình duyệt web chỉ hỗ trợ Notification API khi truy cập qua giao thức bảo mật `https://` hoặc địa chỉ `http://localhost`.

---

## F. Cách sử dụng ứng dụng

Dưới đây là các thao tác chi tiết với tên nút bấm thực tế trong ứng dụng:

### 1. Tạo nhiệm vụ mới (Create a Task)
1. Ở màn hình chính, nhấn vào nút tròn dấu cộng **(+)** ở góc dưới bên phải màn hình.
2. Tại màn hình **Nhiệm vụ mới (New Task)**:
   - Nhập tên việc cần làm vào ô tiêu đề (ví dụ: *Làm bài tập lớn Flutter*).
   - Nhấn vào dòng **Ngày (Date)** nếu muốn chọn ngày hạn chót.
   - Nhấn vào dòng **Giờ (Time)** nếu muốn hẹn giờ cụ thể.
   - Chọn nhãn danh mục bên dưới (*Học tập*, *Công việc*, *Cá nhân*, *Sức khỏe*).
   - Gạt công tắc chuông nếu muốn bật hoặc tắt nhắc nhở trước 10 phút.
3. Cuộn xuống dưới cùng và nhấn nút **Tạo nhiệm vụ (Create Task)**.
4. Nhiệm vụ sẽ xuất hiện ngay lập tức trong danh sách việc cần làm.

### 2. Thêm hạn chót và giờ (Add Due Date & Time)
- **Chọn ngày:** Trong màn hình chọn ngày, bấm vào ngày bạn muốn trên lịch. Bạn cũng có thể bấm nhanh nút **Hôm nay (Today)** hoặc **Ngày mai (Tomorrow)** ở dưới. Sau đó bấm nút **Dùng ngày [X] thg [Y]** (hoặc nút **Xóa ngày** nếu muốn bỏ hẹn ngày).
- **Chọn giờ:** Trong màn hình chọn giờ, bấm các mũi tên lên/xuống để chỉnh **GIỜ** và **PHÚT**, bấm chọn **AM** (sáng) hoặc **PM** (chiều/tối). Sau đó bấm nút **Dùng [giờ:phút AM/PM]**.

### 3. Tìm kiếm công việc (Search)
1. Tại màn hình chính, nhấn vào ô tìm kiếm **Tìm kiếm nhiệm vụ của bạn (Search your tasks)**.
2. Gõ từ khóa bạn muốn tìm.
3. Bạn có thể nhấn vào các tab **Tất cả**, **Hôm nay**, **Sắp tới** hoặc bấm **Thay đổi (Change)** danh mục để thu hẹp kết quả.

### 4. Lọc công việc theo buổi và theo ngày
- Bấm vào tab **Hôm nay (Today)**: Các công việc sẽ được chia theo nhóm thời gian rõ ràng: **BUỔI SÁNG**, **BUỔI CHIỀU**, **BUỔI TỐI**.
- Bấm vào tab **Sắp tới (Upcoming)**: Chỉ xem những việc có lịch trong tương lai.

### 5. Hoàn thành và khôi phục công việc
- Để đánh dấu xong: Nhấn vào ô tròn kiểm tra bên trái mỗi thẻ nhiệm vụ. Thẻ sẽ có hiệu ứng gạch ngang và biến mất nhẹ nhàng vào mục Đã xong.
- Ở dưới màn hình sẽ xuất hiện thông báo nổi. Nếu bấm nhầm, hãy nhấn ngay nút **Hoàn tác (Undo)** để đưa nhiệm vụ quay lại danh sách.

### 6. Xem lại thành tích & mục Đã xong (Completed)
1. Nhấn vào tab **Đã xong (Completed)** ở thanh điều hướng dưới cùng.
2. Bạn sẽ thấy tổng kết số việc đã xong hôm nay, tỷ lệ phần trăm tiến độ và thông điệp khích lệ.
3. Bấm vào biểu tượng ngôi sao lấp lánh ở góc trên bên phải để mở cửa sổ chúc mừng *Ăn mừng chiến thắng nhỏ! ✨*.
4. Bấm vào từng nhiệm vụ trong danh sách để chọn **Đánh dấu chưa xong (Mark Incomplete)** hoặc **Xóa (Delete)**.

### 7. Chuyển đổi ngôn ngữ Tiếng Anh / Tiếng Việt trong Cài đặt
1. Nhấn vào tab **Cài đặt (Settings)** ở thanh điều hướng dưới cùng.
2. Tìm đến mục **Ngôn ngữ (Language)** (có biểu tượng hình quả địa cầu).
3. Bấm vào dòng này để mở danh sách ngôn ngữ.
4. Chọn **Tiếng Việt** hoặc **English**.
5. Toàn bộ chữ trên tất cả các màn hình sẽ được cập nhật sang ngôn ngữ mới ngay lập tức mà không cần khởi động lại ứng dụng.
6. Cài đặt ngôn ngữ được lưu tự động và giữ nguyên khi bạn mở lại ứng dụng lần sau.

---

## G. Lưu trữ dữ liệu và quyền riêng tư

- **Dữ liệu được lưu ở đâu?** Toàn bộ danh sách nhiệm vụ và các tùy chọn cài đặt được lưu trữ cục bộ trực tiếp trên bộ nhớ máy tính/thiết bị của bạn thông qua cơ chế `SharedPreferences` (trên Web tương đương với HTML5 `localStorage`).
- **Dữ liệu có bị mất khi tắt app không?** **Không.** Dữ liệu vẫn được giữ nguyên vẹn khi bạn tắt ứng dụng hoặc đóng trình duyệt và mở lại.
- **Bản Android và bản Web có dùng chung dữ liệu không?** **Không.** Do ứng dụng hoạt động hoàn toàn cục bộ độc lập trên từng thiết bị (Offline-first), bản Web chạy trong môi trường trình duyệt riêng, bản Android chạy trong bộ nhớ điện thoại riêng.
- **Có sử dụng máy chủ đám mây (Cloud) hay Firebase không?** **Không.** Ứng dụng không kết nối đến bất kỳ máy chủ bên ngoài hay dịch vụ đám mây nào, đảm bảo 100% tính riêng tư cho bạn.
- **Quyền riêng tư:** Ứng dụng không thu thập tên, số điện thoại, mật khẩu, vị trí hay bất kỳ thông tin cá nhân nào của bạn. Quyền thông báo chỉ nhằm mục đích phát âm thanh/cảnh báo nhắc việc trên thiết bị của chính bạn.

---

## H. Các lệnh thường dùng

Bảng tổng hợp các lệnh kiểm thử và vận hành dự án đã được xác minh:

| Lệnh | Giải thích chi tiết |
| :--- | :--- |
| `flutter doctor -v` | Kiểm tra toàn diện môi trường cài đặt Flutter, Android SDK, Chrome và Visual Studio. |
| `flutter devices` | Liệt kê tất cả thiết bị thật, máy ảo và trình duyệt đang kết nối sẵn sàng chạy app. |
| `flutter emulators` | Xem danh sách các máy ảo Android đã tạo trên máy tính. |
| `flutter pub get` | Tải về các thư viện phụ thuộc được khai báo trong tệp `pubspec.yaml`. |
| `flutter analyze` | Kiểm tra tĩnh toàn bộ mã nguồn Dart xem có lỗi cú pháp hoặc cảnh báo nào không (Dự án đạt: **0 lỗi**). |
| `flutter test` | Chạy toàn bộ 81 bài kiểm tra tự động của dự án (Dự án đạt: **81/81 bài test vượt qua**). |
| `flutter test test/language_switching_test.dart` | Chạy riêng bộ kiểm tra chuyển đổi ngôn ngữ Anh/Việt và lưu trữ cài đặt. |
| `flutter run -d chrome --web-port 8080` | Chạy ứng dụng trên trình duyệt Chrome tại cổng phát triển cục bộ 8080. |
| `flutter run -d emulator-5554` | Chạy ứng dụng lên máy ảo Android đang mở. |
| `flutter build web` | Đóng gói mã nguồn phiên bản Web thành các tệp tĩnh tối ưu trong thư mục `build/web/`. |

---

## I. Khắc phục sự cố

### 1. Lỗi PowerShell: `flutter : The term 'flutter' is not recognized`
- **Nguyên nhân:** Đường dẫn đến thư mục `bin` của Flutter chưa nằm trong biến môi trường PATH.
- **Cách sửa:** Thêm `D:\Tools\flutter\bin` (hoặc thư mục cài đặt thực tế của bạn) vào PATH trong mục *System Properties -> Environment Variables*, sau đó đóng PowerShell và mở lại một cửa sổ mới.

### 2. Trình duyệt Chrome không mở hoặc không nhận diện
- **Nguyên nhân:** Chrome chưa được cài ở thư mục mặc định hoặc biến môi trường `CHROME_EXECUTABLE` chưa được trỏ đúng.
- **Cách sửa:** Kiểm tra đường dẫn Chrome qua `flutter doctor -v`. Nếu bạn dùng Edge, bạn có thể chạy: `flutter run -d edge`.

### 3. Cổng 8080 đang bị chiếm dụng (`Port 8080 is already in use`)
- **Nguyên nhân:** Có một tiến trình Flutter hoặc ứng dụng web khác đang chạy ở cổng 8080.
- **Cách sửa:**
  - Hoặc tắt tiến trình cũ bằng cách bấm phím `q` trong cửa sổ terminal đang chạy cổng 8080.
  - Hoặc đổi sang cổng khác khi chạy lệnh:
    ```powershell
    flutter run -d chrome --web-port 8081
    ```

### 4. Không tìm thấy máy ảo Android hoặc máy ảo bị offline
- **Nguyên nhân:** Máy ảo Android chưa hoàn tất quá trình khởi động hoặc bị treo tiến trình ADB.
- **Cách sửa:**
  - Chạy lệnh khởi động máy ảo: `flutter emulators --launch Medium_Phone_API_37.0`.
  - Khởi động lại dịch vụ ADB:
    ```powershell
    & "C:\Users\Admin\AppData\Local\Android\sdk\platform-tools\adb.exe" kill-server
    & "C:\Users\Admin\AppData\Local\Android\sdk\platform-tools\adb.exe" start-server
    ```

### 5. Lỗi tải thư viện (`flutter pub get failed`)
- **Nguyên nhân:** Mất kết nối Internet hoặc tường lửa chặn truy cập đến kho `pub.dev`.
- **Cách sửa:** Kiểm tra lại kết nối mạng Internet và chạy lại lệnh `flutter pub get`.

### 6. Cài đặt ngôn ngữ không lưu lại trên Web
- **Nguyên nhân:** Trình duyệt đang bật chế độ Ẩn danh (Incognito/Private) hoặc bạn đã bấm "Xóa dữ liệu trang web / Clear site data".
- **Cách sửa:** Mở trang web ở chế độ duyệt thông thường để trình duyệt cho phép lưu `localStorage`.

---

## J. Cấu trúc thư mục

Dưới đây là sơ đồ cấu trúc các thư mục quan trọng của dự án:

```
to_do_list/
├── lib/                               # Toàn bộ mã nguồn ứng dụng Dart/Flutter
│   ├── core/                          # Các thành phần cốt lõi dùng chung
│   │   ├── localization/              # Dịch vụ đa ngôn ngữ AppLocalizations (Anh & Việt)
│   │   ├── mock/                      # Dữ liệu mẫu (MockTasks) theo chuẩn thiết kế
│   │   ├── models/                    # Lớp dữ liệu (TaskModel, TaskCategory, ...)
│   │   ├── services/                  # Dịch vụ thông báo (NotificationService)
│   │   ├── state/                     # Quản lý trạng thái (TaskStore, SettingsStore)
│   │   ├── theme/                     # Hệ thống màu sắc, viền, khoảng cách, font chữ
│   │   ├── utils/                     # Xử lý thời gian và ngày tháng (TimeUtils)
│   │   └── widgets/                   # Các widget giao diện tái sử dụng (Button, Badge, Nav, ...)
│   ├── features/                      # Các tính năng theo từng màn hình
│   │   ├── completed/                 # Màn hình Đã xong và ăn mừng (CompletedScreen)
│   │   ├── schedule/                  # Màn hình chọn ngày (Date) và chọn giờ (Time)
│   │   ├── search/                    # Màn hình tìm kiếm (SearchScreen)
│   │   ├── settings/                  # Màn hình cài đặt (SettingsScreen)
│   │   └── tasks/                     # Màn hình chính (HomeScreen), tạo/sửa/chi tiết task
│   ├── preview/                       # Bộ xem trước màn hình Figma (ScreenPreviewCatalog)
│   └── main.dart                      # Điểm khởi chạy ứng dụng (Entry point & TodoApp)
├── test/                              # Thư mục kiểm thử tự động (Unit & Widget tests)
│   ├── language_switching_test.dart   # Kiểm thử chuyển đổi ngôn ngữ Anh/Việt & lưu trữ
│   ├── visual_verification_test.dart  # Kiểm thử giao diện và độ phân giải màn hình
│   └── ...                            # Các bộ test logic và sửa lỗi khác
├── android/                           # Cấu hình dự án cho hệ điều hành Android
├── web/                               # Tệp giao diện và manifest cho trình duyệt Web
├── windows/                           # Cấu hình dự án cho hệ điều hành Windows Desktop
├── linux/                             # Cấu hình mẫu cho Linux (chưa kiểm thử trên máy này)
├── macos/                             # Cấu hình mẫu cho macOS (chưa kiểm thử trên máy này)
├── ios/                               # Cấu hình mẫu cho iOS (cần máy tính Apple macOS để build)
├── pubspec.yaml                       # Khai báo thư viện, font chữ và tài nguyên của app
└── README.md                          # Tài liệu hướng dẫn sử dụng và vận hành dự án này
```

*Lưu ý:* Các thư mục như `linux/`, `macos/`, `ios/` được sinh ra mặc định theo tiêu chuẩn khung dự án Flutter. Việc các thư mục này tồn tại không có nghĩa là ứng dụng đã được biên dịch hay thử nghiệm trên các hệ điều hành đó.

---

## K. Tình trạng kiểm thử và giới hạn hiện tại

Báo cáo kết quả kiểm thử thực tế trên hệ thống:

- **Phân tích mã nguồn (`flutter analyze`):**
  - Kết quả: **0 lỗi, 0 cảnh báo** (`No issues found!`).
- **Bộ kiểm thử tự động (`flutter test`):**
  - Kết quả: **81/81 bài kiểm thử vượt qua hoàn toàn (100% Passed)**.
  - Bao gồm: Kiểm thử mặc định Tiếng Anh, chuyển sang Tiếng Việt, chuyển ngược lại Tiếng Anh, kiểm thử ghi nhớ vào SharedPreferences, phục hồi khi mở lại app, kiểm thử nội dung công việc của người dùng không bị dịch nhầm, và kiểm thử không bị tràn bố cục (RenderFlex overflow) trên màn hình hẹp chuẩn 375x812 và 390x844.
- **Nền tảng Web:**
  - Lệnh `flutter build web`: Biên dịch hoàn tất thành công trong 37.1 giây.
  - Lệnh `flutter run -d chrome --web-port 8080`: Chạy ổn định trên Google Chrome.
- **Nền tảng Android:**
  - Android SDK 36.1.0 và JDK 25 được nhận diện đầy đủ. Máy ảo `Medium_Phone_API_37.0` có sẵn trong danh sách máy ảo của hệ thống.
- **Giới hạn hiện tại:**
  - Thông báo trên Web chỉ gửi được khi tab trình duyệt đang mở.
  - Ứng dụng hiện lưu trữ hoàn toàn trên thiết bị của bạn, chưa hỗ trợ đồng bộ đám mây giữa các thiết bị khác nhau.

---

## L. Tài liệu tham khảo

- Hướng dẫn cài đặt Flutter chính thức: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
- Hướng dẫn cấu hình Flutter cho Web: [https://docs.flutter.dev/platform-integration/web](https://docs.flutter.dev/platform-integration/web)
- Hướng dẫn cài đặt và thiết lập Android cho Flutter: [https://docs.flutter.dev/platform-integration/android/setup](https://docs.flutter.dev/platform-integration/android/setup)
- Hướng dẫn quốc tế hóa và đa ngôn ngữ trong Flutter: [https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- Thư viện thông báo cục bộ Android: [https://pub.dev/packages/flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
