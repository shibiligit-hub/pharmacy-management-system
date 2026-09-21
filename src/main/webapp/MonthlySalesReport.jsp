<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%

Connection conn = null;
ResultSet rs = null;
PreparedStatement ps = null;
String month = request.getParameter("month");
try{
	 conn = DBConnection.getConnection();
	 ps = conn.prepareStatement("SELECT PRODUCT_NAME,MONTHNAME(SALE_DATE) AS MONTH_NAME,SUM(PRICE)"
			 +" AS TOTAL_SALES,SUM(QUANTITY) AS TOTAL_QTY FROM"
			+ " SALES WHERE MONTHNAME(SALE_DATE) =? GROUP "
					+"BY PRODUCT_NAME");
	 if(month != null && !month.equals("")){
		    ps.setString(1,month);
		    rs = ps.executeQuery();
		}	 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MonthlySales</title>
<style>
body{
    color:black;
    margin:0;
    padding:0;
    overflow-x:hidden;
    font-family:Arial,sans-serif;
}

h2{
    text-align:center;
    font-size:45px;
    color:black;
}

form{
    text-align:center;
    margin:20px 0;
}

input{
    padding:10px;
    color:black;
    border:1px solid;
    border-radius:5px;
    outline:none;
}

input::placeholder{
    color:black
}
#ok{
    height: 33px;
    width: 110px;
}

button{
    padding:10px 15px;
    color:black;
    border:1px solid ;
    border-radius:5px;
    cursor:pointer;
}

button:hover{
    background:white;
    color:black;
}

table{
    width:80%;
    margin:20px auto;
    border-collapse:collapse;
}

th,
td{
    border:1px solid ;
    padding:12px;
    text-align:center;
    color:black;
}

th{
    font-weight:bold;
}

.back-btn{
    display:block;
    margin:20px auto;
}
</style>
</head>
<body>
<form method="get">
<select name="month" id="ok">
	<option value="JANUARY">JANUARY</option>
	<option value="FEBRUARY">FEBRUARY</option>
	<option value="MARCH">MARCH</option>
	<option value="APRIL">APRIL</option>
	<option value="MAY">MAY</option>
	<option value="JUNE">JUNE</option>
	<option value="JULY">JULY</option>
	<option value="AUGUST">AUGUST</option>
	<option value="SEPTEMBER">SEPTEMBER</option>
	<option value="OCTOBER">OCTOBER</option>
	<option value="NOVEMBER">NOVEMBER</option>
	<option value="DECEMBER">DECEMBER</option>
</select>
<button type="submit">Search</button>
</form>
<table>
<% if(rs != null){ while(rs.next()){ %>
<h2> <%= rs.getString("MONTH_NAME") %> Month</h2>
<tr>
<th>Product Name</th>
<th>Quantity</th>
<th>Total Sales</th>
</tr>
<tr>
<td><%= rs.getString("PRODUCT_NAME") %></td>
<td><%= rs.getFloat("TOTAL_QTY") %></td>
<td><%= rs.getFloat("TOTAL_SALES") %></td>
</tr>
<% } } %>
</table>
</body>
</html>
<%

}
catch(Exception e){

    out.println(
    "<h2>Error : " + e.getMessage() + "</h2>"
    );
}

%>