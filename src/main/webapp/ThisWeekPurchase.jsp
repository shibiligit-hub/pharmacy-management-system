<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%
PreparedStatement pst = null;
Connection conn = null;
ResultSet rs = null;
LocalDate today = LocalDate.now();
LocalDate StartWeek = today.with(java.time.DayOfWeek.MONDAY);
LocalDate EndWeek = today.with(java.time.DayOfWeek.SUNDAY);
try{
	conn = DBConnection.getConnection();
	pst = conn.prepareStatement("SELECT * FROM PURCHASE WHERE PURCHASE_DATE BETWEEN ? AND ?");
	pst.setDate(1,java.sql.Date.valueOf(StartWeek));
	pst.setDate(2,java.sql.Date.valueOf(EndWeek));
	rs = pst.executeQuery();
	
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
if(rs.next()){
%>
<h1 style="text-align:center">This Week Purchase Records</h1>
<label class="labell">Total Purhcase: </label>
<input type="text" id="inp"  readonly>
<table border="1">
<tr>
<th>SL No</th>
<th>Product Name</th>
<th>Supplier Name</th>
<th>Company Name</th>
<th>Quantity</th>
<th>Price</th>
<th>Manufacturing Date</th>
<th>Expiry Date</th>
<th>Invoice No</th>
</tr>
<% do { %>
<tr>
    <td><%= slno++ %></td>
    <td><%= rs.getString("PRODUCT_NAME") %></td>
    <td><%= rs.getString("SUPPLIER_NAME") %></td>
    <td><%= rs.getString("COMPANY_NAME") %></td>
    <td><%= rs.getDouble("QUANTITY") %></td>
    <td class="pr"><%= rs.getDouble("PRICE") %></td>
    <td><%= rs.getDate("MANUFACTURING_DATE") %></td>
    <td><%= rs.getDate("EXPIRY_DATE") %></td>
    <td><%= rs.getInt("INVOICE") %></td>
</tr>
<%} while(rs.next()); %>
</table>
<%
} else {%>
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