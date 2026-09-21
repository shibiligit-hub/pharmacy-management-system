import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import hospital.DBConnection;
import javax.servlet.http.*;


@WebServlet("/DeleteStocks")
public class DeleteStocks extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
	throws IOException,ServletException{
		int id = Integer.parseInt(req.getParameter("ID"));
		
		res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        
		try {
			Connection conn = DBConnection.getConnection();
			
			PreparedStatement Ps = conn.prepareStatement("DELETE FROM STOCKS WHERE S_ID = ?");
			Ps.setInt(1, id);
			
			int i = Ps.executeUpdate();
			if (i > 0) {
                res.sendRedirect("ViewStock.jsp");
            } else {
                out.println("<h2>Delete Failed ❌</h2>");
            }

		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}