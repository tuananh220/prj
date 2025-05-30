/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.RevenueReport;

public class RevenueDAO {
    public List<RevenueReport> getRevenueBy(String period) throws SQLException {
        String sql = "";
        switch (period) {
            case "day":
                sql = "SELECT CAST(order_date AS DATE) AS period, SUM(total_amount) AS revenue FROM orders WHERE status = 'Delivered' GROUP BY CAST(order_date AS DATE)";
                break;
            case "month":
                sql = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS revenue FROM orders WHERE status = 'Delivered' GROUP BY YEAR(order_date), MONTH(order_date)";
                break;
            case "year":
                sql = "SELECT YEAR(order_date) AS period, SUM(total_amount) AS revenue FROM orders WHERE status = 'Delivered' GROUP BY YEAR(order_date)";
                break;
        }

        List<RevenueReport> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RevenueReport r = new RevenueReport();
                if (period.equals("month")) {
                    r.setLabel(rs.getInt("month") + "/" + rs.getInt("year"));
                } else {
                    r.setLabel(rs.getString("period"));
                }
                r.setRevenue(rs.getDouble("revenue"));
                list.add(r);
            }
        }
        return list;
    }
}

