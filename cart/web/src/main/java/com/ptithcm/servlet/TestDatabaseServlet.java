package com.ptithcm.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

@WebServlet(name = "TestDatabaseServlet", urlPatterns = {"/test-db"})
public class TestDatabaseServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<html><body>");
            out.println("<h2>Kiểm tra kết nối Database</h2>");
            
            InitialContext initContext = new InitialContext();
            out.println("1. Tìm JNDI Context: OK<br/>");
            
            DataSource ds = (DataSource) initContext.lookup("jdbc/cosmetics");
            out.println("2. Tìm thấy DataSource: OK<br/>");
            
            Connection conn = ds.getConnection();
            out.println("3. Kết nối Database thành công!<br/>");
            
            out.println("<br/>Thông tin kết nối:<br/>");
            out.println("- Database: " + conn.getCatalog() + "<br/>");
            out.println("- URL: " + conn.getMetaData().getURL() + "<br/>");
            out.println("- Username: " + conn.getMetaData().getUserName() + "<br/>");
            
            // Kiểm tra dữ liệu trong bảng products
            try {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM products");
                
                out.println("<h3>Dữ liệu trong bảng Products:</h3>");
                out.println("<pre>");
                
                // In ra tên cột
                java.sql.ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                for (int i = 1; i <= columnCount; i++) {
                    out.print(metaData.getColumnName(i) + "\t");
                }
                out.println("\n----------------------------------------");
                
                // In ra dữ liệu
                while (rs.next()) {
                    for (int i = 1; i <= columnCount; i++) {
                        out.print(rs.getString(i) + "\t");
                    }
                    out.println();
                }
                out.println("</pre>");
                
                rs.close();
                stmt.close();
            } catch (Exception e) {
                out.println("<h3 style='color:red'>Lỗi truy vấn bảng Products: " + e.getMessage() + "</h3>");
                e.printStackTrace(out);
            }
            
            conn.close();
            out.println("<br/>4. Đóng kết nối thành công!");
            
        } catch (Exception e) {
            out.println("<h3 style='color:red'>Lỗi: " + e.getMessage() + "</h3>");
            e.printStackTrace(out);
        } finally {
            out.println("</body></html>");
        }
    }
}
