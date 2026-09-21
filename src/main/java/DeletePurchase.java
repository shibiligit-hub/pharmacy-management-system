import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import hospital.DBConnection;
import javax.servlet.http.*;


@WebServlet("/DeletePurchase")
public class DeletePurchase extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
	throws IOException,ServletException{
		String supplierName = req.getParameter("supplier");
		
		res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        
		try {
			Connection conn = DBConnection.getConnection();
			
			PreparedStatement Ps = conn.prepareStatement("DELETE FROM PURCHASE WHERE SUPPLIER_NAME = ?");
			PreparedStatement Ps1 = conn.prepareStatement("DELETE FROM STOCKS WHERE SUPPLIER_NAME = ?");
			PreparedStatement Ps2 = conn.prepareStatement("DELETE FROM PURCHASE WHERE SUPPLIER_NAME = ?");
			Ps1.setString(1, supplierName);
			Ps2.setString(1, supplierName);
			Ps1.executeUpdate();
			Ps2.executeUpdate();
			Ps.setString(1, supplierName);
			int i = Ps.executeUpdate();
			if (i > 0) {
                res.sendRedirect("ViewPurchase.jsp");
            } else {
                out.println("<h2>Insert Failed ❌</h2>");
            }
			Ps1.close();
			Ps2.close();
			conn.close();

		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}