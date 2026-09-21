<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%
PreparedStatement ps = null;
ResultSet rs = null;
LocalDate today = LocalDate.now();
Connection conn = null;
try{
	
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT * FROM SALES WHERE SALE_DATE=?	");
	ps.setDate(1, java.sql.Date.valueOf(today));	
	rs = ps.executeQuery();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Today Sales</title>
<style>
table{
    width:90%;
    margin:20px auto;
    border-collapse:collapse;
    background:white;
}

th{
	background-color:blue;
	color:white;
    text-align:left;
    padding:20px 35px;
    font-size:22px;
    font-weight:700;
	border: 1px solid black;    
}

td{
    text-align:left;
    padding:20px 35px;
    font-weight:500;
    font-size:18px;    
	border: 1px solid black;    
}
.sel{
    margin-left: 790px;
    width: 225px;
    height: 37px;
    font-size: 18px;
}
button{
	width: 100px;
	background-color: cornflowerblue;
	color:white;
    height: 33px;
}
.labell{
    font-size: 21px;
    margin-left: 1520px;
    font-weight: bold;
}
input[type="text"]{
	width:70px;
	border:none;
	background-color:#F0F0F2;
	font-size:19px;
	font-weight:bold;
	color:green;
}
</style>
</head>
<body>

<% 
int slno = 1;
int count = 0;
if(rs.next()) {%>
<h1 style="text-align:center">Today Sales Records</h1>
<label class="labell">Total Sales: </label>
<input type="text" id="inp" readonly>
<table border="1">
<tr>
<th>SL No</th>
<th>Product Name</th>
<th>Quantity</th>
<th>Unit Price</th>
<th>Price</th>
<th>Patient Name</th>
<th>Doctor Name</th>
</tr>
<% do{ %>
<tr>
	<td><%= 	slno++ %></td>
    <td><%= rs.getString("PRODUCT_NAME") %></td>
    <td><%= rs.getDouble("QUANTITY") %></td>
    <td><%= rs.getDouble("COST_PRICE") %></td>
    <td class="pri"><%= rs.getDouble("PRICE") %></td>
    <td><%= rs.getString("CUSTOMER_NAME") %></td>
    <td><%= rs.getString("DOCTOR") %></td>
</tr>
<%} while(rs.next()); %>
</table>
<%
} else {
%>

<h2 style="text-align:center;">No Data Found</h2>

<%
}
%>
<script>
function Total(){
	var price = document.getElementsByClassName("pri");
	var total = 0;
	for(var i =0; i< price.length;i++){
		total += parseFloat(price[i].innerText) || 0;
	}
	document.getElementById("inp").value = total;
}
Total();
</script>
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