/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import dal.FoodDAO;
import dal.FoodReviewDAO;
import java.util.List;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */

public class FoodService {

    private final FoodDAO foodDAO = new FoodDAO();
    private final FoodReviewDAO reviewDAO = new FoodReviewDAO();

    /** Lấy danh sách món (đã filter + gán rating, review) */
    public List<Food> getFoods(String keyword, int categoryId) throws SQLException {

        List<Food> foods;
        if (keyword != null && !keyword.trim().isEmpty()) {
            foods = (categoryId == 0)
                    ? foodDAO.searchByName(keyword)
                    : foodDAO.searchByNameAndCategory(keyword, categoryId);
        } else {
            foods = (categoryId == 0)
                    ? foodDAO.getAllFoods()
                    : foodDAO.findByCategory(categoryId);
        }

        // Gán thêm điểm TB & list review (nếu FoodDAO chưa làm)
        for (Food f : foods) {
            f.setAverageRating(reviewDAO.getAverageRating(f.getFoodId()));
            f.setReviews(reviewDAO.getReviewsByFoodId(f.getFoodId()));
        }
        return foods;
    }

    public List<Category> getAllCategories() throws SQLException {
        return foodDAO.getAllCategories();
    }
}

