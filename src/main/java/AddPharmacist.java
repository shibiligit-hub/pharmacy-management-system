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

@WebServlet("/AddPharmacist")
public class AddPharmacist extends HttpServlet {
	protected void doPost(HttpServletRequest requ,HttpServletResponse resp)
		throws IOException,ServletException{
		
		String name = requ.getParameter("name");
		String email = requ.getParameter("email");
		String dob = requ.getParameter("dob");
		String qualifi = requ.getParameter("qualification");
		String exp = requ.getParameter("exp");
		String gender = requ.getParameter("gender");
		String phone = requ.getParameter("phone");
		String addre = requ.getParameter("address");
		String pass = "pharma";
		String type= "PHARMACIST";
		Date dobb = Date.valueOf(dob);
		
		
		resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        
        try {
        	Connection conn = DBConnection.getConnection();
        	
        	PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM PHARMACIST");
        	ResultSet rs1 = ps1.executeQuery();
        	int count = 0;
        	if(rs1.next()) {
        		count = rs1.getInt(1);
        	}
        	String Pharma_ID = String.format("MED%02d", count);
        	
        	String sql = "INSERT INTO PHARMACIST(NAME,EMAIL,QUALIFICATION,EXPERIENCE,GENDER,DOB,"
        			+ "PHONE,ADDRESS,PHARMA_ID) VALUES (?,?,?,?,?,?,?,?,?)";
        	
        	PreparedStatement ps = conn.prepareStatement(sql);        	        	
        	ps.setString(1, name);
        	ps.setString(2, email);
        	ps.setString(3, qualifi);
        	ps.setInt(4,Integer.parseInt(exp));
        	ps.setString(5, gender);        	
        	ps.setDate(6, dobb);
        	ps.setString(7,phone);
        	ps.setString(8, addre);  
        	ps.setString(9, Pharma_ID);        	
        	
        	int i = ps.executeUpdate();
        	
        	String pharmalog = "INSERT INTO LOGIN(USERNAME,PASSWORD,TYPE,LOGIN_ID) VALUE(?,?,?,?)";
        	
        	PreparedStatement log = conn.prepareStatement(pharmalog);
        	log.setString(1,email);
        	log.setString(2, pass);
        	log.setString(3, type);
        	log.setString(4, Pharma_ID);
        	int i1 = log.executeUpdate();
        	
        	if (i > 0 && i1>0) {
                resp.sendRedirect("ViewPharmacists.jsp");
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
