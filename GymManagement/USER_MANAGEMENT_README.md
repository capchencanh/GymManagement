# Hướng dẫn sử dụng chức năng Quản lý tài khoản

## Tổng quan
Chức năng quản lý tài khoản cho phép admin quản lý toàn bộ tài khoản người dùng trong hệ thống phòng gym, bao gồm:
- Xem danh sách tài khoản
- Thêm tài khoản mới
- Chỉnh sửa thông tin tài khoản
- Xem chi tiết tài khoản
- Đặt lại mật khẩu
- Xóa tài khoản

## Các tính năng chính

### 1. Danh sách tài khoản (`/admin/users`)
- **Tìm kiếm**: Tìm kiếm theo tên, email, số điện thoại
- **Lọc theo vai trò**: ADMIN, PT, USER
- **Thống kê**: Hiển thị số lượng tài khoản theo từng vai trò
- **Thao tác nhanh**: Xem, sửa, đặt lại mật khẩu, xóa

### 2. Thêm tài khoản mới (`/admin/users/create`)
- Form nhập thông tin đầy đủ
- Validation real-time
- Mã hóa mật khẩu tự động
- Kiểm tra trùng lặp email/số điện thoại

### 3. Chỉnh sửa tài khoản (`/admin/users/edit/{id}`)
- Cập nhật thông tin cá nhân
- Thay đổi vai trò
- Đổi mật khẩu (tùy chọn)
- Validation và kiểm tra dữ liệu

### 4. Xem chi tiết tài khoản (`/admin/users/view/{id}`)
- Hiển thị đầy đủ thông tin
- Thống kê nhanh (chiều cao, cân nặng)
- Lịch sử tạo/cập nhật
- Các nút thao tác nhanh

### 5. Đặt lại mật khẩu (`/admin/users/reset-password/{id}`)
- Form đặt lại mật khẩu an toàn
- Xác nhận thao tác
- Validation mật khẩu mới

## Cấu trúc dữ liệu

### Entity User
```java
- userId: Integer (Primary Key)
- email: String (Unique)
- phoneNumber: String (Unique)
- passwordHash: String (Encrypted)
- role: Role (ADMIN, PT, USER)
- name: String
- gender: String
- birthdate: Date
- height: Double
- weight: Double
- fitnessGoal: String
- createdAt: Timestamp
- updatedAt: Timestamp
```

### Vai trò người dùng
- **ADMIN**: Quản trị viên hệ thống
- **PT**: Huấn luyện viên
- **USER**: Thành viên phòng gym

## API Endpoints

### Controller: `AdminUserController`
- `GET /admin/users` - Danh sách tài khoản
- `GET /admin/users/create` - Form thêm tài khoản
- `POST /admin/users/create` - Tạo tài khoản
- `GET /admin/users/edit/{id}` - Form sửa tài khoản
- `POST /admin/users/edit/{id}` - Cập nhật tài khoản
- `GET /admin/users/view/{id}` - Xem chi tiết tài khoản
- `GET /admin/users/reset-password/{id}` - Form đặt lại mật khẩu
- `POST /admin/users/reset-password/{id}` - Đặt lại mật khẩu
- `POST /admin/users/delete/{id}` - Xóa tài khoản

## Service Layer

### UserService
Các phương thức chính:
- `getAllUsers()` - Lấy tất cả tài khoản
- `getUserById(Integer id)` - Lấy tài khoản theo ID
- `getUsersByRole(Role role)` - Lấy tài khoản theo vai trò
- `searchUsers(String keyword)` - Tìm kiếm tài khoản
- `createUser(User user)` - Tạo tài khoản mới
- `updateUser(Integer id, User user)` - Cập nhật tài khoản
- `deleteUser(Integer id)` - Xóa tài khoản
- `resetPassword(Integer id, String newPassword)` - Đặt lại mật khẩu

## Repository Layer

### UserRepository
Các phương thức tìm kiếm:
- `findByEmail(String email)`
- `findByPhoneNumber(String phoneNumber)`
- `existsByEmail(String email)`
- `existsByPhoneNumber(String phoneNumber)`
- `findByRole(Role role)`
- `findByKeyword(String keyword)`
- `findByRoleAndKeyword(Role role, String keyword)`

## Giao diện

### Templates Thymeleaf
- `admin/user/list.html` - Danh sách tài khoản
- `admin/user/form.html` - Form thêm/sửa tài khoản
- `admin/user/view.html` - Chi tiết tài khoản
- `admin/user/reset-password.html` - Đặt lại mật khẩu
- `admin/dashboard.html` - Dashboard admin

### CSS tùy chỉnh
- `static/css/admin.css` - Styles cho giao diện admin

## Tính năng bảo mật

### Mã hóa mật khẩu
- Sử dụng BCryptPasswordEncoder
- Mật khẩu được mã hóa tự động khi tạo/cập nhật
- Không lưu trữ mật khẩu dạng plain text

### Validation
- Kiểm tra email hợp lệ
- Kiểm tra số điện thoại
- Kiểm tra trùng lặp email/số điện thoại
- Validation mật khẩu (độ dài tối thiểu)
- Xác nhận mật khẩu khi tạo/sửa

### Phân quyền
- Hiện tại cho phép truy cập tự do (sẽ thêm authentication sau)
- Có thể mở rộng với Spring Security

## Hướng dẫn sử dụng

### 1. Truy cập quản lý tài khoản
1. Vào trang chủ: `http://localhost:8080/`
2. Click vào "Quản lý tài khoản" hoặc truy cập trực tiếp: `http://localhost:8080/admin/users`

### 2. Thêm tài khoản mới
1. Click nút "Thêm tài khoản"
2. Điền đầy đủ thông tin bắt buộc (*)
3. Chọn vai trò phù hợp
4. Nhập mật khẩu và xác nhận
5. Click "Thêm tài khoản"

### 3. Chỉnh sửa tài khoản
1. Từ danh sách, click nút "Chỉnh sửa" (biểu tượng bút chì)
2. Thay đổi thông tin cần thiết
3. Nhập mật khẩu mới nếu muốn đổi
4. Click "Cập nhật"

### 4. Xem chi tiết tài khoản
1. Click nút "Xem chi tiết" (biểu tượng mắt)
2. Xem đầy đủ thông tin tài khoản
3. Có thể thực hiện các thao tác khác từ trang này

### 5. Đặt lại mật khẩu
1. Click nút "Đặt lại mật khẩu" (biểu tượng chìa khóa)
2. Nhập mật khẩu mới
3. Xác nhận mật khẩu
4. Tích vào checkbox xác nhận
5. Click "Đặt lại mật khẩu"

### 6. Xóa tài khoản
1. Click nút "Xóa" (biểu tượng thùng rác)
2. Xác nhận việc xóa trong popup
3. Tài khoản sẽ bị xóa vĩnh viễn

## Lưu ý quan trọng

1. **Backup dữ liệu**: Luôn backup dữ liệu trước khi thực hiện các thao tác quan trọng
2. **Mật khẩu**: Mật khẩu phải có ít nhất 6 ký tự
3. **Email/SĐT**: Không được trùng lặp trong hệ thống
4. **Xóa tài khoản**: Thao tác không thể hoàn tác
5. **Phân quyền**: Cần thêm authentication để bảo mật tốt hơn

## Mở rộng trong tương lai

1. **Authentication & Authorization**: Thêm Spring Security
2. **Audit Log**: Ghi log các thao tác
3. **Import/Export**: Nhập/xuất danh sách tài khoản
4. **Bulk Operations**: Thao tác hàng loạt
5. **Advanced Search**: Tìm kiếm nâng cao
6. **Pagination**: Phân trang cho danh sách lớn
7. **Email Notifications**: Thông báo qua email
8. **Profile Pictures**: Upload ảnh đại diện 