	import java.sql.Connection;
	import java.sql.DriverManager;
	
	public class DBConnection {
	
	    public static Connection getConnection() {
	        Connection con = null;
	
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	
	            con = DriverManager.getConnection(
	                "jdbc:mysql://localhost:3306/PHARMACIST",
	                "root",
	                ""   // or "1234"
	            );
	
	            System.out.println("Connected Successfully ✅");
	
	        } catch (Exception e) {
	            System.out.println("DB Connection Failed ❌");
	            e.printStackTrace();
	        }
	
	        return con;
	    }
	}