import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.Random;
import java.sql.ResultSet;

@WebServlet("/AddPurchase")
public class AddPurchase extends HttpServlet {
	protected void doPost(HttpServletRequest requ,HttpServletResponse resp)
		throws IOException,ServletException{
		
		String supliern = requ.getParameter("supplier");
		String company = requ.getParameter("company");
		String productn = requ.getParameter("product");
		String quantity = requ.getParameter("quantity");
		String uprice = requ.getParameter("Uprice");
		String price = requ.getParameter("price");
		String invoice = requ.getParameter("inv");
		String mdate = requ.getParameter("pdate");
		Random ran = new Random();
		int Rack = ran.nextInt(0,5);
		java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
		String expdate = requ.getParameter("exp");
		
		resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
	
        try {
        	Connection conn = DBConnection.getConnection();
        	String sql = "INSERT INTO PURCHASE(Supplier_name,Product_name,Quantity,Price,Purchase_date,Expiry_date,"
        			+ "COMPANY_NAME,UNIT_COST_PRICE,MANUFACTURING_DATE,INVOICE,RACK) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        	String sqlO = "UPDATE STOCKS SET PRODUCT_QUANTITY =  PRODUCT_QUANTITY + ?"
        			+ " WHERE PRODUCT_NAME=?";
        	PreparedStatement ps = conn.prepareStatement(sql);
        	PreparedStatement ps1 = conn.prepareStatement(sqlO);
        	PreparedStatement check = conn.prepareStatement(
        		    "SELECT PRODUCT_QUANTITY FROM STOCKS WHERE PRODUCT_NAME=? AND SUPPLIER_NAME=? AND MANUFACTURING_DATE=?"
        		    + " AND EXPIRY_DATE=? ");
        	
        	
        		Date mdatee = Date.valueOf(mdate);
        		Date exp = Date.valueOf(expdate);
        		check.setString(1, productn);
        		check.setString(2, supliern);
        		check.setDate(3, mdatee);
        		check.setDate(4,exp);


        		ResultSet rs = check.executeQuery();
        	
        	ps.setString(1, supliern);
        	ps.setString(2, productn);
        	ps.setInt(3,Integer.parseInt(quantity));
        	ps.setFloat(4, Float.parseFloat(price));
        	ps.setDate(5, today);
        	ps.setDate(6, exp);
        	ps.setString(7, company);
        	Double im = Double.valueOf(uprice);
        	Double imo = Double.valueOf(quantity);
        	ps.setDouble(8, im);
        	ps.setDate(9, mdatee);
        	ps.setString(10, invoice);
        	ps.setInt(11, Rack);
        	int i1 = 0;

        	if(rs.next()){

        	    ps1.setDouble(1, imo);
        	    ps1.setString(2, productn);

        	    i1 = ps1.executeUpdate();

        	}
        	else{

        	    PreparedStatement insert = conn.prepareStatement(
        	        "INSERT INTO STOCKS(PRODUCT_NAME, PRODUCT_QUANTITY,SUPPLIER_NAME,MANUFACTURING_DATE,EXPIRY_DATE"
        	        + ",PURCHASE_DATE,RACK_NO) VALUES(?,?,?,?,?,?,?)");

        	    insert.setString(1, productn);
        	    insert.setInt(2, Integer.parseInt(quantity));
        	    insert.setString(3, supliern);
        	    insert.setDate(4, mdatee);
        	    insert.setDate(5, exp);
        	    insert.setDate(6, today);
        	    insert.setInt(7, Rack);


        	    i1 = insert.executeUpdate();
        	}
        	ps.setDouble(8, im);
        	int i = ps.executeUpdate();
        	if (i > 0 && i1 > 0) {
                resp.sendRedirect("ViewPurchase.jsp");
            } else {
                out.println("<h2>Insert Failed ❌</h2>");
            }
        	}
        	catch(Exception e) {
        		out.println("<h2>Error: " + e.getMessage() + "</h2>");
        		e.printStackTrace();
        	} 
       }

}
