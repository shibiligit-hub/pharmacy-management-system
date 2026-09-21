import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Submit")
public class Submit extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try {

            Connection conn = DBConnection.getConnection();

            String product = req.getParameter("product");
            double qty = Double.parseDouble(req.getParameter("qty"));
            double unitPrice = Double.parseDouble(req.getParameter("cprice"));
            double price = Double.parseDouble(req.getParameter("price"));
            String customer = req.getParameter("cname");
            String doctor = req.getParameter("dname");

            PreparedStatement sale = conn.prepareStatement(
                "INSERT INTO SALES(PRODUCT_NAME,PRICE,SALE_DATE,QUANTITY,CUSTOMER_NAME,COST_PRICE,DOCTOR) "
                + "VALUES(?,?,CURDATE(),?,?,?,?)"
            );

            sale.setString(1, product);
            sale.setDouble(2, price);
            sale.setDouble(3, qty);
            sale.setString(4, customer);
            sale.setDouble(5, unitPrice);
            sale.setString(6, doctor);

            int i = sale.executeUpdate();

            PreparedStatement sales = conn.prepareStatement(
                "INSERT INTO SALES(PRODUCT_NAME,PRICE,SALE_DATE,QUANTITY,CUSTOMER_NAME,COST_PRICE,DOCTOR) "
                + "SELECT PRODUCT_NAME,PRICE,SALE_DATE,QUANTITY,PATIENT_NAME,UNIT_PRICE,DOCTOR_NAME "
                + "FROM SALES_TP;"
            );
            PreparedStatement stock1 = conn.prepareStatement(
            	    "UPDATE STOCKS SET PRODUCT_QUANTITY = PRODUCT_QUANTITY - ? WHERE PRODUCT_NAME = ?"
            	);

            	stock1.setDouble(1, qty);
            	stock1.setString(2, product);

            	stock1.executeUpdate();

            sales.executeUpdate();

            PreparedStatement stock = conn.prepareStatement(
            	    "UPDATE STOCKS s " +
            	    "JOIN SALES_TP t ON s.PRODUCT_NAME = t.PRODUCT_NAME " +
            	    "SET s.PRODUCT_QUANTITY = s.PRODUCT_QUANTITY - t.QUANTITY"
            	);

            	stock.executeUpdate();
            
            
            PreparedStatement dele = conn.prepareStatement("DELETE FROM SALES_TP");
            dele.executeUpdate();
            res.sendRedirect("ViewSales.jsp");

            
        } catch(Exception e) {
            out.println("<h2>Error : " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
}