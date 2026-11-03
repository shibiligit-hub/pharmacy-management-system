<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@  page import="java.time.LocalDate" %>
<%
String type = request.getParameter("type");
LocalDate today = LocalDate.now();
LocalDate tendayBefore = today.plusDays(10);
Connection conn = DBConnection.getConnection();
PreparedStatement noti = conn.prepareStatement("SELECT * FROM STOCKS WHERE EXPIRY_DATE BETWEEN CURDATE() AND ?");
noti.setDate(1,java.sql.Date.valueOf(tendayBefore));
ResultSet rsnoti = noti.executeQuery();


int alqty = 50;
PreparedStatement lownoti = conn.prepareStatement("SELECT * FROM STOCKS WHERE PRODUCT_QUANTITY <= ?");
lownoti.setInt(1,alqty);
ResultSet lowrs = lownoti.executeQuery();


PreparedStatement expirespre = conn.prepareStatement("SELECT * FROM STOCKS WHERE EXPIRY_DATE < CURDATE()");
ResultSet resexpiry = expirespre.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
h4{
    font-size: 34px;
    text-align: center;
}
table{
    width:80%;
    margin:20px auto;
    border-collapse:collapse;
    background:white;
}

th{
	background-color:blue;
	color:white;
    text-align:left;
    padding:14px;
    font-size:22px;
    font-weight:700;
	border: 1px solid black;    
}

td{
    text-align:center;
    padding:13px;
    font-weight:500;
    font-size:18px;    
	border: 1px solid black;    
}
</style>
</head>
<body>
<%int count=1; %>
<%if(type.equals("low") || type.equals("all")) {%>
<h4>Low Stock Items</h4>
	<table class="lowstock">
		<tr>
			<th>SL No</th>
			<th>Product Name</th>
			<th>Quantity</th>
			<th>Invoice Number</th>
			<th>Supplier Name</th>
		</tr>
		<% while(lowrs.next()){ %>
		<tr>
			<td><%=count++ %></td>
			<td><%=lowrs.getString("PRODUCT_NAME") %></td>
			<td><%=lowrs.getInt("PRODUCT_QUANTITY") %></td>
			<td><%=lowrs.getInt("RACK_NO") %></td>
			<td><%=lowrs.getString("SUPPLIER_NAME") %></td>
		</tr>
		<%}%>
	</table>
	<%}else if(type.equals("expiredmedicine") || type.equals("all")){ %>
<h4>Expired Items</h4>
	<table class="expired">
		<tr>
			<th>SL No</th>
			<th>Product Name</th>
			<th>Purchase Date</th>
			<th>Manufacturing Date</th>
			<th>Expired Date</th>
			<th>Supplier Name</th>
		</tr>
		<% while(resexpiry.next()){ %>
		<tr>
			<td><%=count++ %></td>
			<td><%=resexpiry.getString("PRODUCT_NAME") %></td>
			<td><%=resexpiry.getDate("PURCHASE_DATE") %></td>
			<td><%=resexpiry.getDate("MANUFACTURING_DATE") %></td>
			<td><%=resexpiry.getDate("EXPIRY_DATE") %></td>
			<td><%=resexpiry.getString("SUPPLIER_NAME") %></td>
		</tr>
		<%} %>
	</table>
	<%}else if(type.equals("soon") || type.equals("all")){ %>
<h4>Expiring Soon</h4>

	<table class="soon">
		<tr>
			<th>SL No</th>
			<th>Product Name</th>
			<th>Purchase Date</th>
			<th>Manufacturing Date</th>
			<th>Expired Date</th>
			<th>Supplier Name</th>
		</tr>
		<% while(rsnoti.next()){ %>
		<tr>
			<td><%=count++ %></td>
			<td><%=rsnoti.getString("PRODUCT_NAME") %></td>
			<td><%=rsnoti.getDate("PURCHASE_DATE") %></td>
			<td><%=rsnoti.getDate("MANUFACTURING_DATE") %></td>
			<td><%=rsnoti.getDate("EXPIRY_DATE") %></td>
			<td><%=rsnoti.getString("SUPPLIER_NAME") %></td>
		</tr>
		<%} %>
	</table>
	<%}else{ %>
	<h4>Nothing Found</h4>
	<%} %>
</body>
</html>