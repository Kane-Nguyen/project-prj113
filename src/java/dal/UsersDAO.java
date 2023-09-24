// Import các lớp và gói cần thiết
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Giả sử rằng DBContext của bạn đã cài đặt một biến kết nối tên là 'connection'.
public class UsersDAO extends DBContext {

    // Phương thức để thêm một người dùng mới vào cơ sở dữ liệu
    public boolean insertUser(String email, String password, String fullname) {
        // Truy vấn SQL để thêm một người dùng mới
        String sql = "INSERT INTO Users (Email, PassWord, FullName) VALUES (?, ?, ?)";

        try {
            // Tạo đối tượng PreparedStatement để thực thi truy vấn SQL
            PreparedStatement st = connection.prepareStatement(sql);

            // Thiết lập giá trị cho email, password và fullname trong truy vấn
            st.setString(1, email);
            st.setString(2, password);
            st.setString(3, fullname);

            // Thực thi lệnh insert và lưu số hàng bị ảnh hưởng
            int affectedRows = st.executeUpdate();

            // Kiểm tra xem người dùng đã được thêm thành công hay không
            if (affectedRows > 0) {
                return true;  // Người dùng đã được thêm thành công
            }
        } catch (SQLException e) {
            // In ra màn hình stack trace cho bất kỳ ngoại lệ SQL nào
            System.out.println(e);
        }
        return false;  // Thất bại trong việc thêm người dùng
    }

    // Phương thức để lấy tất cả các bản ghi người dùng từ cơ sở dữ liệu
    public List<Users> getAll() {

        // Khởi tạo một ArrayList mới để lưu đối tượng Users sẽ được tạo từ các bản ghi trong cơ sở dữ liệu
        List<Users> list = new ArrayList<>();

        // Truy vấn SQL dưới dạng một chuỗi để chọn tất cả các bản ghi từ bảng Users
        String sql = "select * from Users";

        try {
            // Tạo đối tượng PreparedStatement để thực thi truy vấn SQL
            PreparedStatement st = connection.prepareStatement(sql);

            // Thực thi truy vấn SQL và lưu kết quả vào ResultSet
            ResultSet rs = st.executeQuery();

            // Duyệt qua ResultSet và tạo đối tượng Users mới cho mỗi bản ghi, sau đó thêm nó vào danh sách
            while (rs.next()) {
                Users u = new Users(rs.getInt("UserID"), rs.getString("FullName"), rs.getDate("BirthDate"), rs.getString("PhoneNumber"), rs.getString("Email"), rs.getString("PassWord"), rs.getString("Address"), rs.getDate("RegistrationDate"), rs.getString("UserRole"));
                list.add(u);
            }
        } catch (SQLException e) {
            // In ra màn hình stack trace cho bất kỳ ngoại lệ SQL nào
            System.out.println(e);
        }

        // Trả về danh sách các đối tượng Users được tạo từ các bản ghi trong cơ sở dữ liệu
        return list;
    }

}
