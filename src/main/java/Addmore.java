import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Addmore")
public class Addmore extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
	throws IOException,ServletException{
		String name = req.getParameter("product");
		String cprice = req.getParameter("cprice");
		String price = req.getParameter("price");
		String quantity = req.getParameter("qty");
		java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
		String cname = req.getParameter("cname");
		String doctor = req.getParameter("dname");
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		
		try {
		Connection conn = DBConnection.getConnection();
		String  sql="INSERT INTO SALES_TP(PRODUCT_NAME,"
				+ "QUANTITY,PRICE,SALE_DATE,UNIT_PRICE,PATIENT_NAME,DOCTOR_NAME) VALUES(?,?,?,?,?,?,?)";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1,name);
		Double li = Double.valueOf(cprice);
		ps.setDouble(2, li);
		Double pri = Double.valueOf(price);
		ps.setDouble(3,pri);
		Double qua = Double.valueOf(quantity);
		ps.setDouble(5,qua);
		ps.setDate(4 ,today);	
		ps.setString(6,cname);
		ps.setString(7,doctor);
		int i = ps.executeUpdate();
		PreparedStatement stock = conn.prepareStatement(
			    "UPDATE STOCKS SET PRODUCT_QUANTITY = PRODUCT_QUANTITY - ? WHERE PRODUCT_NAME = ?"
			);

			stock.setDouble(1, qua);
			stock.setString(2, name);

			stock.executeUpdate();
        if (i > 0) {
            res.sendRedirect("AddSales.jsp?showTable=true");
        } else {
            out.println("<h2>Insert Failed ❌</h2>");
        }
		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}