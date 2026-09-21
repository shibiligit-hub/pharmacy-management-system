import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.ResultSet;


@WebServlet("/login")
public class login extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
	throws IOException,ServletException{
		String username = req.getParameter("use");
		String pass = req.getParameter("pass");
		
		res.setContentType("text/html");
        PrintWriter out = res.getWriter();
		try {
			Connection conn = DBConnection.getConnection();
			
			PreparedStatement Ps = conn.prepareStatement("SELECT * FROM LOGIN WHERE USERNAME=? AND PASSWORD=?");
			Ps.setString(1, username);
			Ps.setString(2,pass);
			ResultSet rs = Ps.executeQuery();

            if(rs.next()) {
            		HttpSession session = req.getSession();
            		session.setAttribute("pharma_name",rs.getString("USERNAME"));
            		session.setAttribute("pharma_id",rs.getInt("LOGIN_ID"));
            		if(rs.getString("TYPE").equals("ADMIN")) {
                        res.sendRedirect("Index1.jsp");
            		}else {
                	res.sendRedirect("PharmacistHome.jsp");
                }
            		
            }
             else {
                out.println("Invalid Username or Password");

            }
		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}