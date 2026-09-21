import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddMedicine")
public class AddMedicine extends HttpServlet{
	protected void doPost(HttpServletRequest req,HttpServletResponse res)
		throws ServletException,IOException{
		String medname = req.getParameter("mednam");
		String cat = req.getParameter("cat");
		String brand = req.getParameter("Brand");
		String batc = req.getParameter("batch");
		String mda = req.getParameter("mdate");
		String exp = req.getParameter("exp");
		String pric = req.getParameter("price");
		String qnt = req.getParameter("qnt");
		String supn = req.getParameter("supnaem");
		String des = req.getParameter("des");
		
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
		
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "INSERT INTO MEDICINE(MEDICINE_NAME,CATEGORY,BRAND,BATCH_NO,MANUFACTURED_DATE,"
					+ "EXPIRY_DATE,PRICE,QUANTITY,SUPP_NAME,DESCRIPTIONn)"
			+ " VALUES(?,?,?,?,?,?,?,?,?,?)";
			
			PreparedStatement Ps = conn.prepareStatement(sql);
			Ps.setString(1, medname);
			Ps.setString(2,cat);
			Ps.setString(3,brand);
			Ps.setInt(4,Integer.valueOf(batc));
			Date mandate =Date.valueOf(mda);
			Date expdate =Date.valueOf(exp);
			Ps.setDate(5, mandate);
			Ps.setDate(6, expdate);
			Ps.setInt(7,Integer.parseInt(pric));
			Ps.setString(8, qnt);
			Ps.setString(9, supn);
			Ps.setString(10, des);

			int i = Ps.executeUpdate();
            if (i > 0) {
                out.println("<h2>Data Inserted Successfully ✅</h2>");
            } else {
                out.println("<h2>Insert Failed ❌</h2>");
            }
		}catch(Exception e){
			out.println("<h2>Error: " + e.getMessage() + "</h2>");	
		}
	}
}
