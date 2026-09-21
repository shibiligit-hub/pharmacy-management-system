import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditStocks")
public class EditStocks extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try {
            Connection conn = DBConnection.getConnection();
            int id = Integer.parseInt(req.getParameter("ID"));
            String product = req.getParameter("productName");
            double qty = Double.parseDouble(req.getParameter("Quantity"));
            String purhcaseDate = req.getParameter("purhcaseDate"); 
            String ManufacturingDate = req.getParameter("ManufacturingDate"); 
            String ExpiryDate = req.getParameter("ExpiryDate"); 
            String supplierName = req.getParameter("supplierName");
            int rack = Integer.parseInt(req.getParameter("rackNo"));
            
            PreparedStatement stock = conn.prepareStatement(
                    "UPDATE STOCKS SET PRODUCT_NAME = ?,PRODUCT_QUANTITY =?,SUPPLIER_NAME = ?,"
                    + "MANUFACTURING_DATE = ?"
                    + ",EXPIRY_DATE =?,PURCHASE_DATE = ?,RACK_NO = ? WHERE S_ID = ?"
                );

            stock.setString(1, product);
            stock.setDouble(2, qty);
            stock.setString(3, supplierName);
            Date Manufacturing = Date.valueOf(ManufacturingDate);
            stock.setDate(4, Manufacturing);
            Date Expiry = Date.valueOf(ExpiryDate);
            stock.setDate(5, Expiry);
            Date purchase = Date.valueOf(purhcaseDate);
            stock.setDate(6, purchase);
            stock.setInt(7, rack);
            stock.setInt(8, id);
            int i = stock.executeUpdate();


            if(i > 0){
                res.sendRedirect("ViewStock.jsp");
            } else {
                out.println("<h2>Stock not Updated</h2>");
            }

        } catch(Exception e) {
            out.println("<h2>Error : " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
}