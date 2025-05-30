/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import  java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.FoodReview;

/**
 *
 * @author Admin
 */
public class FoodReviewDAO {
     public void addReview(int foodId, int userId, int rating, String comment) {
        String sql = "INSERT INTO food_reviews (food_id, user_id, rating, comment, review_date) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
     
      public double getAverageRating(int foodId) {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM food_reviews WHERE food_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy danh sách đánh giá
    public List<FoodReview> getReviewsByFoodId(int foodId) {
    List<FoodReview> list = new ArrayList<>();
    String sql = "SELECT r.*, u.full_name FROM food_reviews r JOIN users u ON r.user_id = u.user_id WHERE r.food_id = ? ORDER BY r.review_date DESC";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, foodId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            FoodReview review = new FoodReview();
            review.setReviewId(rs.getInt("review_id"));
            review.setFoodId(rs.getInt("food_id"));
            review.setUserId(rs.getInt("user_id"));
            review.setRating(rs.getInt("rating"));
            review.setComment(rs.getString("comment"));
            review.setReviewDate(rs.getTimestamp("review_date"));
            review.setUserName(rs.getString("full_name"));
            list.add(review);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}
