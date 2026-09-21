	<%@ page import="java.sql.*" %>
	<%@ page import="hospital.DBConnection" %>
	<%
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement ps = null;
	String month = request.getParameter("month");
	String year = request.getParameter("year");
	try{
		conn = DBConnection.getConnection();
		ps = conn.prepareStatement(
			    "SELECT p.Product_name, " +
			    "MONTHNAME(p.Purchase_date) AS PurchaseMonth, " +
			    "SUM(p.Quantity) AS PurchaseQty, " +
			    "SUM(p.Price) AS PurchaseCost, " +
			    "SUM(s.Quantity) AS SoldQty, " +
			    "SUM(s.Price) AS SalesRevenue " +
			    "FROM purchase p " +
			    "JOIN sales s ON p.Product_name = s.Product_name " +
			    "WHERE MONTH(p.Purchase_date)=? AND YEAR(p.Purchase_date)=? " +
			    "GROUP BY p.Product_name, MONTH(p.Purchase_date)"
			);
	
		if(month != null && !month.equals("")){
		    ps.setInt(1, Integer.parseInt(month));
		    ps.setInt(2, Integer.parseInt(year));
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
	#ok{
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
	<form>
	<input type="number" name="year">
	<select name="month" id="ok" >
		<option value="">MONTH</option>
		<option value="1">JANUARY</option>
		<option value="2">FEBRUARY</option>
		<option value="3">MARCH</option>
		<option value="4">APRIL</option>
		<option value="5">MAY</option>
		<option value="6">JUNE</option>
		<option value="7">JULY</option>
		<option value="8">AUGUST</option>
		<option value="9">SEPTEMBER</option>
		<option value="10">OCTOBER</option>
		<option value="11">NOVEMBER</option>
		<option value="12">DECEMBER</option>
	</select>    
	<button type="submit">Search</button>
	</form>
	<body>
	<table>
	<tr>
	<th>Product Name</th>
	<th>Period</th>
	<th>Purchased Quantity</th>
	<th>Purchase Cost</th>
	<th>Sold Quantity</th>
	<th>Sales Revenue</th>
	<th>OutCome</th>
	</tr>
	<% if(rs!= null){while(rs.next()){ %>
	<%
	double purchaseCost = rs.getDouble("PurchaseCost");
	double salesRevenue = rs.getDouble("SalesRevenue");
	double outcome = salesRevenue - purchaseCost;
	String status;
	if(outcome > 0){
		status = "profit";
	} else if (outcome==0){
		status = "No profit";
	}else{
		status = "loss";
	}
	%>
	<tr>
	<td><%= rs.getString("Product_name") %>
	<td><%= rs.getString("PurchaseMonth") %></td>
	<td><%= rs.getDouble("PurchaseQty") %></td>
	<td><%= rs.getDouble("PurchaseCost") %></td>
	<td><%= rs.getDouble("SoldQty") %></td>
	<td><%= rs.getDouble("SalesRevenue") %></td>
	<td><%= outcome %>(<%= status %>)</td>
	</tr>
	<%} }%>
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