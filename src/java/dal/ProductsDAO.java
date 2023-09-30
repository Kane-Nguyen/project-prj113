package dal;

import model.Products;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductsDAO extends DBContext {
    public List<Products> getAllProducts() {
        List<Products> productsList = new ArrayList<>();
        String sql = "SELECT * FROM Products";

        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Products product = new Products();
                product.setProductID(resultSet.getInt("ProductID"));
                product.setProductName(resultSet.getString("ProductName"));
                product.setDescription(resultSet.getString("Description"));
                product.setPrice(resultSet.getDouble("Price"));
                product.setImageURL(resultSet.getString("ImageURL"));
                product.setStockQuantity(resultSet.getInt("StockQuantity"));
                product.setCategory(resultSet.getString("Category"));
                product.setManufacturer(resultSet.getString("Manufacturer"));
                product.setDateAdded(resultSet.getString("DateAdded"));

                productsList.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productsList;
    }
}
