import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditPharmacist")
public class EditPharmacist extends HttpServlet{
	protected void doPost(HttpServletRequest requ,HttpServletResponse resp)
		throws IOException,ServletException{
		
		String name = requ.getParameter("name");
		String email = requ.getParameter("email");
		String phid = requ.getParameter("pharma_id");
		String qualification = requ.getParameter("qualification");
		String experience = requ.getParameter("experience");
		String gender = requ.getParameter("gender");
		String dob = requ.getParameter("dob");
		String address = requ.getParameter("address");
		String phone = requ.getParameter("phone");
		
		resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
	
        try {
        	Connection conn = DBConnection.getConnection();
        	String sql =    	"UPDATE PHARMACIST SET  NAME = ?,EMAIL =?,QUALIFICATION=?,EXPERIENCE=?,"
        			+ "GENDER=?,DOB=?,ADDRESS=?,PHONE=? WHERE PHARMA_ID =?";
        	
        	PreparedStatement ps = conn.prepareStatement(sql);
        	
        		Date dobb = Date.valueOf(dob);
 
            	ps.setString(1, name);
            	ps.setString(2, email);
            	ps.setString(3, qualification);
            	ps.setString(4, experience);
            	ps.setString(5, gender);
            	ps.setDate(6, dobb);
            	ps.setString(7, address);
            	ps.setString(8, phone);
            	ps.setString(9, phid);
            	int i = ps.executeUpdate();
        		
        	if (i > 0) {
                resp.sendRedirect("ViewPharmacists.jsp");
            } else {
            	out.println("<h2>Pharmacist updated: ");            }
        	}
        	catch(Exception e) {
        		out.println("<h2>Error: " + e.getMessage() + "</h2>");
        		e.printStackTrace();
      } 
   }
}
