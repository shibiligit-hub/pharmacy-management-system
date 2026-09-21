<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%
PreparedStatement pst = null;
Connection conn = null;
ResultSet rst = null;
LocalDate today = LocalDate.now();
LocalDate StartYear = today.withDayOfYear(1);
LocalDate Endyear = today.withDayOfYear(today.lengthOfYear());

try{
	conn = DBConnection.getConnection();
	pst = conn.prepareStatement("SELECT * FROM SALES WHERE SALE_DATE BETWEEN ? AND ?");
	pst.setDate(1,java.sql.Date.valueOf(StartYear));
	pst.setDate(2,java.sql.Date.valueOf(Endyear));
	rst = pst.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
if(rst.next()){
%>
<h1 style="text-align:center">This Year Sales Records</h1>
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
<th>Sale Date</th>
</tr>
<%do { %>
<tr>
	<td><%= 	slno++ %></td>
    <td><%= rst.getString("PRODUCT_NAME") %></td>
    <td><%= rst.getDouble("QUANTITY") %></td>
    <td><%= rst.getDouble("COST_PRICE") %></td>
    <td class="pr"><%= rst.getDouble("PRICE") %></td>
    <td><%= rst.getString("CUSTOMER_NAME") %></td>
    <td><%= rst.getString("DOCTOR") %></td>
    <td><%= rst.getDate("SALE_DATE") %></td>
</tr>
<%} while(rst.next()); %>
</table>
<%
} else {
%>

<h2 style="text-align:center;">No Data Found</h2>
<% } %>
<script>
function Total(){
	var pr = document.getElementsByClassName("pr");
	var total = 0;
	for (var i=0;i < pr.length;i++){
		total += parseFloat(pr[i].innerText) || 0;
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