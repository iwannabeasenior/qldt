# qldt

chức năng chỉnh sửa thông tin người dùng
sử dụng bộ nhớ tạm của thiết bị cá nhân(shared_preferences) để có thể lưu lại dữ liệu người dùng kể cả khi
reload lại app => tốn bộ nhớ nhưng ko đáng kể 

có thể sử dụng
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.clear();

để xóa dữ liệu trên shared_preferences


