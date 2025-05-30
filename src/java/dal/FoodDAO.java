/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.List;
import model.Food;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Set;
import model.Category;

/**
 *
 * @author Admin
 */
public class FoodDAO {

    public List<Food> getAllFoods() throws SQLException {
        List<Food> list = new ArrayList<>();

        Set<Integer> topSellerIds = fetchTopSellerIds(3);

        String sql = """
            SELECT f.food_id, f.name, f.description, f.price, f.image_url,
                   f.discount_percent,
                   c.category_id, c.name  AS cat_name,
                   COALESCE(fs.total_sold,0) AS total_sold,
                   (SELECT AVG(CAST(r.rating AS FLOAT))
                    FROM food_reviews r WHERE r.food_id = f.food_id) AS avg_rate
            FROM   foods f
            LEFT  JOIN categories c ON f.category_id = c.category_id
            LEFT  JOIN ( SELECT od.food_id, SUM(od.quantity) AS total_sold
                         FROM   order_details od
                         JOIN   orders o ON od.order_id = o.order_id
                         WHERE  o.status = 'Delivered' 
                         GROUP  BY od.food_id ) fs
                   ON fs.food_id = f.food_id
            """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            FoodReviewDAO rvDao = new FoodReviewDAO();

            while (rs.next()) {
                Food f = new Food();
                f.setFoodId(rs.getInt("food_id"));
                f.setName(rs.getString("name"));
                f.setDescription(rs.getString("description"));
                f.setPrice(rs.getDouble("price"));
                f.setImageUrl(rs.getString("image_url"));

                /* category */
                if (rs.getObject("category_id") != null) {
                    Category cat = new Category(rs.getInt("category_id"),
                            rs.getString("cat_name"));
                    f.setCategory(cat);
                }

                /* rating, discount, total_sold, topSeller */
                f.setAverageRating(rs.getDouble("avg_rate"));
                f.setDiscountPercent(rs.getDouble("discount_percent"));
                f.setTotalQuantitySold(rs.getInt("total_sold"));
                f.setTopSeller(topSellerIds.contains(f.getFoodId()));

                /* reviews */
                f.setReviews(rvDao.getReviewsByFoodId(f.getFoodId()));

                list.add(f);
            }
        }
        return list;
    }

    private Set<Integer> fetchTopSellerIds(int limit) throws SQLException {
        Set<Integer> ids = new HashSet<>();
        String sql = """
            SELECT TOP (?) od.food_id, SUM(od.quantity) AS qty
            FROM order_details od
            JOIN orders o ON od.order_id = o.order_id AND o.status='Delivered'
            GROUP BY od.food_id
            ORDER BY qty DESC
            """;
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt(1));
                }
            }
        }
        return ids;
    }
    
    
    
    public List<Category> getAllCategories() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT category_id, name FROM categories";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        }
        return list;
    }

    public void add(Food f) throws SQLException {
        String sql = "INSERT INTO foods (name, description, price, image_url, category_id, discount_percent, top_seller) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getDescription());
            ps.setDouble(3, f.getPrice());
            ps.setString(4, f.getImageUrl());
            ps.setInt(5, f.getCategory().getCategoryId());
            ps.setInt    (6, (int) f.getDiscountPercent());
            ps.setBoolean(7, f.isTopSeller());
            ps.executeUpdate();
        }
    }

    public Food getById(int id) throws SQLException {
        String sql = "SELECT * FROM foods WHERE food_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Food f = new Food();
                    f.setFoodId(rs.getInt("food_id"));
                    f.setName(rs.getString("name"));
                    f.setDescription(rs.getString("description"));
                    f.setPrice(rs.getDouble("price"));
                    f.setImageUrl(rs.getString("image_url"));
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    f.setDiscountPercent(rs.getDouble("discount_percent"));
                    f.setCategory(cat);
                    return f;
                }
            }
        }
        return null;
    }
    
    public List<Food> searchByName(String keyword) throws SQLException {
    List<Food> list = new ArrayList<>();
    Set<Integer> topSellerIds = fetchTopSellerIds(100);

    String sql = """
        SELECT f.food_id, f.name, f.description, f.price, f.image_url,
               f.discount_percent,
               c.category_id, c.name AS cat_name,
               COALESCE(fs.total_sold,0) AS total_sold,
               (SELECT AVG(CAST(r.rating AS FLOAT))
                FROM food_reviews r WHERE r.food_id = f.food_id) AS avg_rate
        FROM foods f
        LEFT JOIN categories c ON f.category_id = c.category_id
        LEFT JOIN (
            SELECT od.food_id, SUM(od.quantity) AS total_sold
            FROM order_details od
            JOIN orders o ON od.order_id = o.order_id
            WHERE o.status = 'Delivered'
            GROUP BY od.food_id
        ) fs ON f.food_id = fs.food_id
        WHERE f.name LIKE ?
    """;

    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, "%" + keyword + "%");
        try (ResultSet rs = ps.executeQuery()) {
            FoodReviewDAO rvDao = new FoodReviewDAO();
            while (rs.next()) {
                Category cat = new Category(rs.getInt("category_id"), rs.getString("cat_name"));

                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                food.setCategory(cat);
                food.setDiscountPercent(rs.getDouble("discount_percent"));
                food.setTotalQuantitySold(rs.getInt("total_sold"));
                food.setAverageRating(rs.getDouble("avg_rate"));
                food.setTopSeller(topSellerIds.contains(food.getFoodId()));

                food.setReviews(rvDao.getReviewsByFoodId(food.getFoodId()));

                list.add(food);
            }
        }
    }
    return list;
}

    public List<Food> searchByNameAndCategory(String keyword, int categoryId) throws SQLException {
    List<Food> list = new ArrayList<>();
    Set<Integer> topSellerIds = fetchTopSellerIds(100);

    String sql = """
        SELECT f.food_id, f.name, f.description, f.price, f.image_url,
               f.discount_percent,
               c.category_id, c.name AS cat_name,
               COALESCE(fs.total_sold, 0) AS total_sold,
               (SELECT AVG(CAST(r.rating AS FLOAT))
                FROM food_reviews r WHERE r.food_id = f.food_id) AS avg_rate
        FROM foods f
        JOIN categories c ON f.category_id = c.category_id
        LEFT JOIN (
            SELECT od.food_id, SUM(od.quantity) AS total_sold
            FROM order_details od
            JOIN orders o ON od.order_id = o.order_id
            WHERE o.status = 'Delivered'
            GROUP BY od.food_id
        ) fs ON f.food_id = fs.food_id
        WHERE f.name LIKE ? AND f.category_id = ?
    """;

    try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, "%" + keyword + "%");
        ps.setInt(2, categoryId);

        try (ResultSet rs = ps.executeQuery()) {
            FoodReviewDAO rvDao = new FoodReviewDAO();
            while (rs.next()) {
                Category cat = new Category(rs.getInt("category_id"), rs.getString("cat_name"));

                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                food.setCategory(cat);
                food.setDiscountPercent(rs.getDouble("discount_percent"));
                food.setTotalQuantitySold(rs.getInt("total_sold"));
                food.setAverageRating(rs.getDouble("avg_rate"));
                food.setTopSeller(topSellerIds.contains(food.getFoodId()));

                food.setReviews(rvDao.getReviewsByFoodId(food.getFoodId()));

                list.add(food);
            }
        }
    }
    return list;
}


    public void update(Food f) throws SQLException {
        String sql = "UPDATE foods SET name=?, description=?, price=?, image_url=?, category_id=?, discount_percent=? WHERE food_id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getDescription());
            ps.setDouble(3, f.getPrice());
            ps.setString(4, f.getImageUrl());
            ps.setInt(5, f.getCategory().getCategoryId());
            ps.setDouble(6, f.getDiscountPercent());
            ps.setInt(7, f.getFoodId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM foods WHERE food_id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    
    public List<Food> getFoodsByPage(String keyword, Integer categoryId, int pageIndex, int pageSize) throws SQLException {
    List<Food> list = new ArrayList<>();
    Set<Integer> topSellerIds = fetchTopSellerIds(100);

    // Tạo câu lệnh SQL với phân trang (OFFSET-FETCH của SQL Server)
    String baseSql = """
        SELECT f.food_id, f.name, f.description, f.price, f.image_url,
               f.discount_percent,
               c.category_id, c.name AS cat_name,
               COALESCE(fs.total_sold, 0) AS total_sold,
               (SELECT AVG(CAST(r.rating AS FLOAT))
                FROM food_reviews r WHERE r.food_id = f.food_id) AS avg_rate
        FROM foods f
        LEFT JOIN categories c ON f.category_id = c.category_id
        LEFT JOIN (
            SELECT od.food_id, SUM(od.quantity) AS total_sold
            FROM order_details od
            JOIN orders o ON od.order_id = o.order_id
            WHERE o.status = 'Delivered'
            GROUP BY od.food_id
        ) fs ON f.food_id = fs.food_id
        WHERE f.name LIKE ?
    """;

    if (categoryId != null && categoryId > 0) {
        baseSql += " AND f.category_id = ?";
    }

    baseSql += " ORDER BY f.food_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(baseSql)) {
        
        int paramIndex = 1;
        ps.setString(paramIndex++, "%" + keyword + "%");
        if (categoryId != null && categoryId > 0) {
            ps.setInt(paramIndex++, categoryId);
        }
        ps.setInt(paramIndex++, (pageIndex - 1) * pageSize); // OFFSET
        ps.setInt(paramIndex++, pageSize);                   // FETCH NEXT

        try (ResultSet rs = ps.executeQuery()) {
            FoodReviewDAO rvDao = new FoodReviewDAO();
            while (rs.next()) {
                Food food = new Food();
                food.setFoodId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                Category cat = null;
                if (rs.getObject("category_id") != null) {
                    cat = new Category(rs.getInt("category_id"), rs.getString("cat_name"));
                }
                food.setCategory(cat);
                food.setDiscountPercent(rs.getDouble("discount_percent"));
                food.setTotalQuantitySold(rs.getInt("total_sold"));
                food.setAverageRating(rs.getDouble("avg_rate"));
                food.setTopSeller(topSellerIds.contains(food.getFoodId()));
                food.setReviews(rvDao.getReviewsByFoodId(food.getFoodId()));

                list.add(food);
            }
        }
    }
    return list;
}


    public List<Food> findByCategory(int categoryId) throws SQLException {
        List<Food> list = new ArrayList<>();

        // Lấy danh sách top seller trước
        Set<Integer> topSellerIds = fetchTopSellerIds(100);

        String sql = """
        SELECT f.food_id, f.name, f.description, f.price, f.image_url,
               f.discount_percent,
               c.category_id, c.name AS cat_name,
               COALESCE(fs.total_sold,0) AS total_sold,
               (SELECT AVG(CAST(r.rating AS FLOAT))
                FROM food_reviews r WHERE r.food_id = f.food_id) AS avg_rate
        FROM   foods f
        JOIN   categories c ON f.category_id = c.category_id
        LEFT JOIN (
            SELECT od.food_id, SUM(od.quantity) AS total_sold
            FROM order_details od
            JOIN orders o ON od.order_id = o.order_id
            WHERE o.status = 'Delivered'
            GROUP BY od.food_id
        ) fs ON f.food_id = fs.food_id
        WHERE f.category_id = ?
    """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                FoodReviewDAO rvDao = new FoodReviewDAO();

                while (rs.next()) {
                    Category cat = new Category(rs.getInt("category_id"), rs.getString("cat_name"));

                    Food food = new Food();
                    food.setFoodId(rs.getInt("food_id"));
                    food.setName(rs.getString("name"));
                    food.setDescription(rs.getString("description"));
                    food.setPrice(rs.getDouble("price"));
                    food.setImageUrl(rs.getString("image_url"));
                    food.setCategory(cat);
                    food.setDiscountPercent(rs.getDouble("discount_percent"));
                    food.setTotalQuantitySold(rs.getInt("total_sold"));
                    food.setAverageRating(rs.getDouble("avg_rate"));
                    food.setTopSeller(topSellerIds.contains(food.getFoodId()));

                    // Set reviews
                    food.setReviews(rvDao.getReviewsByFoodId(food.getFoodId()));

                    list.add(food);
                }
            }
        }

        return list;
    }
}
