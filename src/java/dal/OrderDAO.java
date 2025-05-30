package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Food;
import model.Order;
import model.OrderDetail;

public class OrderDAO {
    public List<Order> getOrdersByUserAndStatus(int userId, String status) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ?";
        if (status != null && !status.equals("All")) {
            sql += " AND status = ?";
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (status != null && !status.equals("All")) {
                ps.setString(2, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setDeliveryAddress(rs.getString("delivery_address"));
                o.setDeliveryPhone(rs.getString("delivery_phone"));
                o.setNote(rs.getString("note"));
                list.add(o);
            }
        }
        return list;
    }

    public void cancelOrder(int orderId, int userId) throws SQLException {
        String sql = "UPDATE orders SET status = 'Cancelled' WHERE order_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    public int createOrder(Order order) throws SQLException {
        String sqlOrder = "INSERT INTO orders (user_id, total_amount, status, delivery_address, delivery_phone, note) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO order_details (order_id, food_id, quantity, price) VALUES (?,?,?,?)";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getStatus());
            psOrder.setString(4, order.getDeliveryAddress());
            psOrder.setString(5, order.getDeliveryPhone());
            psOrder.setString(6, order.getNote());
            psOrder.executeUpdate();

            rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);
            else throw new SQLException("Không lấy được order_id mới");

            psDetail = conn.prepareStatement(sqlDetail);
            for (OrderDetail d : order.getOrderDetails()) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, d.getFood().getFoodId());
                psDetail.setInt(3, d.getQuantity());
                psDetail.setDouble(4, d.getPrice());
                psDetail.addBatch();
            }
            psDetail.executeBatch();

            conn.commit();
            return orderId;

        } catch (SQLException ex) {
            if (conn != null) conn.rollback();
            throw ex;
        } finally {
            if (rs != null) rs.close();
            if (psOrder != null) psOrder.close();
            if (psDetail != null) psDetail.close();
            if (conn != null) conn.setAutoCommit(true);
        }
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sqlOrders = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        String sqlDetails = "SELECT od.*, f.name, f.price, f.description, f.image_url FROM order_details od JOIN foods f ON od.food_id = f.food_id WHERE od.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psOrder = conn.prepareStatement(sqlOrders);
             PreparedStatement psDetail = conn.prepareStatement(sqlDetails)) {

            psOrder.setInt(1, userId);
            ResultSet rsOrder = psOrder.executeQuery();

            while (rsOrder.next()) {
                Order o = new Order();
                o.setOrderId(rsOrder.getInt("order_id"));
                o.setUserId(rsOrder.getInt("user_id"));
                o.setOrderDate(rsOrder.getTimestamp("order_date"));
                o.setTotalAmount(rsOrder.getDouble("total_amount"));
                o.setStatus(rsOrder.getString("status"));
                o.setDeliveryAddress(rsOrder.getString("delivery_address"));
                o.setDeliveryPhone(rsOrder.getString("delivery_phone"));
                o.setNote(rsOrder.getString("note"));

                psDetail.setInt(1, o.getOrderId());
                ResultSet rsDet = psDetail.executeQuery();
                List<OrderDetail> details = new ArrayList<>();
                while (rsDet.next()) {
                    Food f = new Food();
                    f.setFoodId(rsDet.getInt("food_id"));
                    f.setName(rsDet.getString("name"));
                    f.setPrice(rsDet.getDouble("price"));
                    f.setDescription(rsDet.getString("description"));
                    f.setImageUrl(rsDet.getString("image_url"));

                    OrderDetail od = new OrderDetail();
                    od.setOrderDetailId(rsDet.getInt("order_detail_id"));
                    od.setFood(f);
                    od.setQuantity(rsDet.getInt("quantity"));
                    od.setPrice(rsDet.getDouble("price"));
                    details.add(od);
                }
                o.setOrderDetails(details);
                list.add(o);
                rsDet.close();
            }
            rsOrder.close();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setDeliveryAddress(rs.getString("delivery_address"));
                o.setDeliveryPhone(rs.getString("delivery_phone"));
                o.setNote(rs.getString("note"));
                return o;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setDeliveryAddress(rs.getString("delivery_address"));
                o.setDeliveryPhone(rs.getString("delivery_phone"));
                o.setNote(rs.getString("note"));
                list.add(o);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
  
}
