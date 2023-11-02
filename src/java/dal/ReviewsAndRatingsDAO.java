package dal;

import model.ReviewsAndRatings;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewsAndRatingsDAO extends DBContext {

    // Lấy tất cả đánh giá và đánh giá từ cơ sở dữ liệu
    public List<ReviewsAndRatings> getAllReviewsAndRatings() {
        List<ReviewsAndRatings> reviewsAndRatingsList = new ArrayList<>();
        String sql = "SELECT * FROM ReviewsAndRatings";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                ReviewsAndRatings r = new ReviewsAndRatings(
                        rs.getInt("ReviewID"),
                        rs.getInt("UserID"),
                        rs.getString("ProductID"),
                        rs.getString("Comment"),
                        rs.getInt("Rating"),
                        rs.getString("DatePosted")
                );
                reviewsAndRatingsList.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return reviewsAndRatingsList;
    }

    // Thêm một đánh giá mới vào cơ sở dữ liệu
    public boolean addReview(int userID, String productID, String comment, int rating) {
        String sql = "INSERT INTO ReviewsAndRatings (userID, productID, comment, rating) VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, userID);
            statement.setString(2, productID);
            statement.setString(3, comment);
            statement.setInt(4, rating);

            int rows = statement.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println(e);;
        }

        return false;
    }

    public List<ReviewsAndRatings> getLatestRatingsByUserForProduct(String productID) {
        List<ReviewsAndRatings> latestRatingsList = new ArrayList<>();

        String sql
                = "WITH LatestRatings AS ("
                + "SELECT "
                + "ReviewID,"
                + "UserID,"
                + "ProductID,"
                + "Rating,"
                + "Comment,"
                + "DatePosted,"
                + "ROW_NUMBER() OVER(PARTITION BY UserID, ProductID ORDER BY DatePosted DESC) as rownum "
                + "FROM "
                + "ReviewsAndRatings "
                + "WHERE "
                + "ProductID = ?"
                + ") "
                + "SELECT "
                + "ReviewID,"
                + "UserID,"
                + "ProductID,"
                + "Rating,"
                + "Comment,"
                + "DatePosted "
                + "FROM "
                + "LatestRatings "
                + "WHERE "
                + "rownum = 1 "
                + "ORDER BY "
                + "UserID";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, productID);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                ReviewsAndRatings r = new ReviewsAndRatings(
                        rs.getInt("ReviewID"),
                        rs.getInt("UserID"),
                        rs.getString("ProductID"),
                        rs.getString("Comment"),
                        rs.getInt("Rating"),
                        rs.getString("DatePosted")
                );
                latestRatingsList.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return latestRatingsList;
    }

    public List<ReviewsAndRatings> getReviewsByProductID(String productID) {
        List<ReviewsAndRatings> reviews = new ArrayList<>();
        String sql = "SELECT * FROM ReviewsAndRatings WHERE ProductID = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, productID);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                ReviewsAndRatings review = new ReviewsAndRatings(
                        rs.getInt("ReviewID"),
                        rs.getInt("UserID"),
                        rs.getString("ProductID"),
                        rs.getString("Comment"),
                        rs.getInt("Rating"),
                        rs.getString("DatePosted")
                );
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return reviews;
    }

    public static void main(String[] args) {
        ReviewsAndRatingsDAO r = new ReviewsAndRatingsDAO();
        List<ReviewsAndRatings> u = r.getAllReviewsAndRatings();
        String n = "D4987D84-7C40-4773-B6E0-0E4E95049FF4";
        List<ReviewsAndRatings> l = r.getReviewsByProductID(n);

        System.out.println(u.get(0).getDatePosted());
//        System.out.println(r.getLatestRatingsByUserForProduct("83AD62A2-E58B-4648-A2C9-3A08E6FDA180").get(0).getRating());
        for (int i = 0; i < r.getLatestRatingsByUserForProduct("83AD62A2-E58B-4648-A2C9-3A08E6FDA180").size(); i++) {
            System.out.println(r.getLatestRatingsByUserForProduct("83AD62A2-E58B-4648-A2C9-3A08E6FDA180").get(i).getRating());
        }
        System.out.println(l.size());
    }
}
