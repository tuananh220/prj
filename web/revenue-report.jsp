<%@ page import="java.util.List" %>
<%@ page import="model.RevenueReport" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Báo cáo doanh thu</title>
    <meta charset="UTF-8">

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f7f9fc;
            padding: 30px 20px;
            color: #333;
            max-width: 900px;
            margin: auto;
        }

        h2 {
            text-align: center;
            color: #1e90ff;
            margin-bottom: 25px;
            font-weight: 700;
        }

        form {
            margin-bottom: 20px;
            text-align: center;
        }

        select {
            padding: 8px 14px;
            border-radius: 6px;
            border: 1.5px solid #ccc;
            font-size: 1rem;
            cursor: pointer;
            transition: border-color 0.3s ease;
        }

        select:hover, select:focus {
            border-color: #1e90ff;
            outline: none;
            box-shadow: 0 0 6px rgba(30,144,255,0.4);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 14px 18px;
            border-bottom: 1px solid #eee;
            text-align: center;
            font-weight: 600;
        }

        th {
            background-color: #1e90ff;
            color: white;
        }

        tr:last-child td {
            border-bottom: none;
        }

        /* Chart container */
        #chart-container {
            margin-top: 40px;
            background: white;
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
         .btn-back-menu {
        display: inline-block;
        padding: 12px 28px;
        background-color: #1e90ff;
        color: white;
        font-weight: 600;
        text-decoration: none;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(30,144,255,0.4);
        transition: background-color 0.3s ease, box-shadow 0.3s ease;
    }
    .btn-back-menu:hover {
        background-color: #0d6efd;
        box-shadow: 0 6px 20px rgba(13,110,253,0.6);
    }
    </style>
</head>
<body>
    <h2>Báo cáo doanh thu</h2>

    <form method="get" action="revenue-report">
        <label>Chọn kiểu báo cáo: </label>
        <select name="period" onchange="this.form.submit()">
            <option value="day" <%= "day".equals(request.getAttribute("period")) ? "selected" : "" %>>Theo ngày</option>
            <option value="month" <%= "month".equals(request.getAttribute("period")) ? "selected" : "" %>>Theo tháng</option>
            <option value="year" <%= "year".equals(request.getAttribute("period")) ? "selected" : "" %>>Theo năm</option>
        </select>
    </form>

    <table>
        <tr>
            <th>Thời gian</th>
            <th>Doanh thu (đ)</th>
        </tr>
        <%
            List<RevenueReport> reports = (List<RevenueReport>) request.getAttribute("reports");
            if (reports != null && !reports.isEmpty()) {
                for (RevenueReport r : reports) {
        %>
        <tr>
            <td><%= r.getLabel() %></td>
            <td><%= String.format("%,.0f", r.getRevenue()) %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="2">Không có dữ liệu báo cáo</td>
        </tr>
        <% } %>
    </table>

    <div id="chart-container">
        <canvas id="revenueChart"></canvas>
    </div>

    <script>
        // Lấy dữ liệu từ server qua JSP
        const labels = [
            <% if (reports != null) {
                for (int i = 0; i < reports.size(); i++) {
                    out.print("\"" + reports.get(i).getLabel() + "\"");
                    if (i < reports.size() - 1) out.print(",");
                }
            } %>
        ];
        const data = [
            <% if (reports != null) {
                for (int i = 0; i < reports.size(); i++) {
                    out.print(reports.get(i).getRevenue());
                    if (i < reports.size() - 1) out.print(",");
                }
            } %>
        ];

        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (đ)',
                    data: data,
                    backgroundColor: 'rgba(30, 144, 255, 0.7)',
                    borderColor: 'rgba(30, 144, 255, 1)',
                    borderWidth: 1,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y.toLocaleString('vi-VN') + " đ";
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + " đ";
                            }
                        }
                    }
                }
            }
        });
    </script>
    <div style="text-align: center; margin-top: 30px;">
    <a href="admin-menu.jsp" class="btn-back-menu">Trở về Menu</a>
</div>
</body>
</html>
