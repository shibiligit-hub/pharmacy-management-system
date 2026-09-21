import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import hospital.DBConnection;
import javax.servlet.http.*;


@WebServlet("/DeleteSales")
public class DeleteSales extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
	throws IOException,ServletException{
		String productName = req.getParameter("product");
		
		res.setContentType("text/html");
        PrintWriter out = res.getWriter();
		try {
			Connection conn = DBConnection.getConnection();
			
			PreparedStatement Ps = conn.prepareStatement("DELETE FROM SALES WHERE PRODUCT_NAME = ?");


			Ps.setString(1, productName);
			int i = Ps.executeUpdate();
			if (i > 0) {
                res.sendRedirect("ViewSales.jsp");
            } else {
                out.println("<h2>Insert Failed ❌</h2>");
            }

		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}