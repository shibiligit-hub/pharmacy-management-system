<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String month = request.getParameter("month");
try{
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT Product_name,SUM(QUANTITY) AS TOTAL_QUANTITY,"
			+"MONTHNAME(Purchase_date) AS MONTH,COMPANY_NAME,Supplier_name,"
			+" SUM(PRICE) AS TOTAL_PURCHASE FROM purchase WHERE "
			+"MONTHNAME(Purchase_date)=? GROUP BY Product_name" );
	if(month != null && !month.equals("")){
	    ps.setString(1, month);
	    rs = ps.executeQuery();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body{
    background:transparent;
    color:white;
    margin:0;
    padding:0;
    overflow-x:hidden;
    font-family:Arial,sans-serif;
}

h1{
    text-align:center;
    font-size:45px;
    color:white;
}

form{
    text-align:center;
    margin:20px 0;
}

input{
    padding:10px;
    background:transparent;
    color:white;
    border:1px solid white;
    border-radius:5px;
    outline:none;
}

input::placeholder{
    color:white;
}
#mohana{
    height: 33px;
    width: 110px;
}

button{
    padding:10px 15px;
    background:transparent;
    color:white;
    border:1px solid white;
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
    background:transparent;
}

th,
td{
    border:1px solid white;
    padding:12px;
    text-align:center;
    color:white;
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
<select name="month" id="mohana">
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
<button type="submit" >Search</button>
</form>
<table>
<tr>
<th>Product Name</th>
<th>Quantity</th>
<th>Supplier Name</th>
<th>Company Name</th>
<th>Month</th>
<th>Total Amount</th>
</tr>
<%
if(rs != null){
    while(rs.next()){
%><tr>
<td><%= rs.getString("Product_name") %></td>
<td><%= rs.getFloat("TOTAL_QUANTITY") %></td>
<td><%= rs.getString("Supplier_name") %></td>
<td><%= rs.getString("COMPANY_NAME") %></td>
<td><%= rs.getString("MONTH") %></td>
<td><%= rs.getString("TOTAL_PURCHASE") %></td>
</tr>
<% } }%>
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