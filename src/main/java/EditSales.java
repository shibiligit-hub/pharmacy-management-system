import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditSales")
public class EditSales extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try {

            Connection conn = DBConnection.getConnection();
            int id = Integer.parseInt(req.getParameter("id"));
            String product = req.getParameter("product");
            double qty = Double.parseDouble(req.getParameter("qty"));
            double unitPrice = Double.parseDouble(req.getParameter("cprice"));
            double price = Double.parseDouble(req.getParameter("price"));
            String customer = req.getParameter("cname");
            String doctor = req.getParameter("dname");

            PreparedStatement sale = conn.prepareStatement(
                "UPDATE SALES SET PRODUCT_NAME=?,PRICE=?,QUANTITY=?,CUSTOMER_NAME=?,"
                + "COST_PRICE=?,DOCTOR=? WHERE ID=?"
            );

            sale.setString(1, product);
            sale.setDouble(2, price);
            sale.setDouble(3, qty);
            sale.setString(4, customer);
            sale.setDouble(5, unitPrice);
            sale.setString(6, doctor);
            	sale.setInt(7, id); 
            int i = sale.executeUpdate();

            PreparedStatement stock = conn.prepareStatement(
                "UPDATE STOCKS SET PRODUCT_QUANTITY = PRODUCT_QUANTITY - ? "
                + "WHERE PRODUCT_NAME = ?"
            );

            stock.setDouble(1, qty);
            stock.setString(2, product);

            stock.executeUpdate();

            if(i > 0){
                res.sendRedirect("ViewSales.jsp");
            } else {
                out.println("<h2>Sales not added</h2>");
            }

        } catch(Exception e) {
            out.println("<h2>Error : " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
}