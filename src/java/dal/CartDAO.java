/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.util.List;
import model.Category;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import model.CartItem;
/**
 *
 * @author Admin
 */
public class CartDAO {
    public List<CartItem> getCartItemsByUserId(int userId) throws SQLException {
    List<CartItem> list = new ArrayList<>();

    String sql = """
        SELECT c.food_id, f.name, c.quantity,
               f.price, f.discount_percent
        FROM cart c
        JOIN foods f ON c.food_id = f.food_id
        WHERE c.user_id = ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            double original = rs.getDouble("price");
            int    disc     = rs.getInt("discount_percent");
            double finalP   = original * (100 - disc) / 100.0;

            CartItem item = new CartItem();
            item.setFoodId(rs.getInt("food_id"));
            item.setFoodName(rs.getString("name"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(finalP);          // giá đã giảm
            
            list.add(item);
        }
    }
    return list;
}

    
    public void addOrUpdateCart(int userId, int foodId, int quantity) throws SQLException {
    String checkSql = "SELECT quantity FROM cart WHERE user_id = ? AND food_id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
        checkPs.setInt(1, userId);
        checkPs.setInt(2, foodId);
        ResultSet rs = checkPs.executeQuery();
        if (rs.next()) {
            int oldQty = rs.getInt("quantity");
            String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND food_id = ?";
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                updatePs.setInt(1, oldQty + quantity);
                updatePs.setInt(2, userId);
                updatePs.setInt(3, foodId);
                updatePs.executeUpdate();
            }
        } else {
            String insertSql = "INSERT INTO cart(user_id, food_id, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setInt(1, userId);
                insertPs.setInt(2, foodId);
                insertPs.setInt(3, quantity);
                insertPs.executeUpdate();
            }
        }
    }
}
    
    

    public List<CartItem> getByUser(int userId) throws SQLException {
        String sql = """
    SELECT ct.food_id, ct.quantity,
           f.name, f.image_url,
           f.price, f.discount_percent
    FROM cart ct
    JOIN foods f ON ct.food_id = f.food_id
    WHERE ct.user_id = ?
""";

        List<CartItem> items = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // map...
                }
            }
        }
        return items;
    }

    public void clear(int userId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
    
     /** Cập nhật số lượng cho 1 món cụ thể trong giỏ */
    public void updateQuantity(int userId, int foodId, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, foodId);
            ps.executeUpdate();
        }
    }

    /** Xoá 1 món khỏi giỏ */
    public void removeItem(int userId, int foodId) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ? AND food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, foodId);
            ps.executeUpdate();
        }
    }
}

