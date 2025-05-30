/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Admin
 */
public class Food {
    private int foodId;
    private String name;
    private String description;
    private double price;
    private String imageUrl;
    private Category category;
     private double averageRating;          // Điểm TB
    private List<FoodReview> reviews; 
    private double discountPercent; // phần trăm giảm giá
        private int totalQuantitySold;  // tổng số lượng bán ra
    private boolean topSeller;      // đánh dấu món top seller// Danh sách bình luận

    public int getTotalQuantitySold() {
        return totalQuantitySold;
    }

    public void setTotalQuantitySold(int totalQuantitySold) {
        this.totalQuantitySold = totalQuantitySold;
    }

    
    
    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public boolean isTopSeller() {
        return topSeller;
    }

    public void setTopSeller(boolean topSeller) {
        this.topSeller = topSeller;
    }

    /* ===== getter / setter mặc định đã có ===== */

    public double getAverageRating() {     // <-- JSP sẽ gọi hàm này
        return averageRating;
    }
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public List<FoodReview> getReviews() { // <-- JSP sẽ dùng
        return reviews;
    }
    public void setReviews(List<FoodReview> reviews) {
        this.reviews = reviews;
    }

    public Food() {}
    public Food(int foodId, String name, String description, double price,
            String imageUrl, Category category, int totalQuantitySold, double discountPercent,boolean topSeller) {
    this.foodId = foodId;
    this.name = name;
    this.description = description;
    this.price = price;
    this.imageUrl = imageUrl;
    this.category = category;
    this.totalQuantitySold = totalQuantitySold;
    this.discountPercent = discountPercent;
    this.topSeller = topSeller;
}

    
    
    // getters, setters

    public int getFoodId() {
        return foodId;
    }

    public void setFoodId(int foodId) {
        this.foodId = foodId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
