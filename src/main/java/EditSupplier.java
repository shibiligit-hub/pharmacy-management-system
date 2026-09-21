import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditSupplier")
public class EditSupplier extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
		throws ServletException,IOException{
		String supname = req.getParameter("supplierna");
		String cname = req.getParameter("companynam");
		String phone = req.getParameter("phone");
		String email = req.getParameter("email");
		int id = Integer.parseInt(req.getParameter("id"));
		String prod = req.getParameter("product");
		String gstno = req.getParameter("gstnu");
		
		if (!email.toLowerCase().endsWith("@gmail.com")) {
		    res.setContentType("text/html");
		    PrintWriter out = res.getWriter();
		    out.println("<h2>Only Gmail addresses are allowed.</h2>");
		    return;
		}
		
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
		
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "UPDATE SUPPLIER SET SUPPLIER_NAME=?,COMPANY_NAME=?,"
					+ "PHONE=?,EMAIL=?,PRODUCT_NAME=?,GST_NUMBER=? WHERE SUPP_ID = ?";
			
			
			PreparedStatement Ps = conn.prepareStatement(sql);
			Ps.setString(1, supname);
			Ps.setString(2,cname);
			Ps.setLong(3,Long.parseLong(phone));
			Ps.setString(4,email);
			Ps.setString(5, prod);
			Ps.setLong(6,Long.parseLong(gstno));
			Ps.setInt(7,id);
			int i = Ps.executeUpdate();
            if (i > 0) {
                res.sendRedirect("ViewSupplier.jsp");
            } else {
                out.println("<h2>Insert Failed ❌</h2>");
            }
		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}
