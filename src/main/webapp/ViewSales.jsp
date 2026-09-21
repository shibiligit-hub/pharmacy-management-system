<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
int currentPage = 1;
int recordsPage = 5;
if(request.getParameter("page")!= null){
	currentPage = Integer.parseInt(request.getParameter("page"));
}
int Start = (currentPage - 1) * recordsPage;
%>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String product = request.getParameter("product");

try{
conn = DBConnection.getConnection();
if(product == null || product.isEmpty()){
	ps = conn.prepareStatement("SELECT * FROM SALES LIMIT ?,?");
	ps.setInt(1,Start);
	ps.setInt(2,recordsPage);
	rs = ps.executeQuery();
}else{
	ps = conn.prepareStatement("SELECT * FROM SALES WHERE PRODUCT_NAME LIKE ? OR CUSTOMER_NAME LIKE ?");
	ps.setString(1,"%" + product + "%" );
	ps.setString(2,"%" + product + "%" );
	rs = ps.executeQuery();
}
	PreparedStatement countpas = conn.prepareStatement("SELECT COUNT(*) FROM SALES");
	ResultSet rscount = countpas.executeQuery();
	int totalRecords = 0;
if(rscount.next()){
	totalRecords = rscount.getInt(1);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sales Records</title>
<style>
body{
    margin:0;
    overflow-x:hidden;
    font-family:Arial, sans-serif;
    background:#F0F0F2;
}
.heading-section{
    display: flex;
    align-items: center;
    margin-left:100px;
}
.top-section {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.heading-text{
	margin-left:20px;
	margin-top:10px;
}
input[type="text"]{
	width:500px;
	height:35px;
	font-size:19px;
	margin-top:45px;
	margin-left:600px;
}
.tentries{	
	display: flex;
    margin-top: 35px;
    margin-left: 60px;
    font-size: 20px;
    font-weight: bold;
}
table{
    width:95%;
    margin:auto;
    border-collapse:collapse;
    background:white;
    margin-top:10px;	
}
th{
	background-color:blue;
	color:white;
    font-size:22px;
    font-weight:600;
    text-align:left;
    padding:20px 40px;
	border: 1px solid black;    
}
td{
    font-size:18px;
    font-weight:400;
    text-align:left;
    padding:0px 20px;
	border: 1px solid black;    
    color:black;
}
tr:last-child td{
    border-bottom:none;
}
button{
    padding:8px 15px;
    cursor:pointer;
}
.hello{
	background-color:white;
	margin-top: 8px;
    	border: none;
    	border-radius: 5px;
    	cursor: pointer;
    	gap:5px;
}
.hai{
	margin-top: 8px;
    background-color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-left: -3px;
}
.back-btn{
    display:block;
    margin:20px auto;
}
.search{
    width: 115px;
    background-color: #315BEA;
    height: 40px;
    color: white;
    font-size:19px;
}
.reset{
    width: 115px;
    background-color: #F5A623;
    height: 40px;
    color: white;
    font-size:19px;
}
.photo img{
	width: 80px;
    height: 80px;
    object-fit: contain;
    margin-top: 37px;
}
.navigation{
    width:95%;
    margin:20px auto;
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
}

.label-style{
	padding:10px 20px;
    font-size:15px;
    border-radius:5px;
    cursor:pointer;
	display:block;
	margin:20px auto;
}

.prev-btn{
    justify-self:start;
}

.next-btn{
    justify-self:end;
}

.nav-buttons{
    background-color:blue;
    color:white;
    width:83px;
    height:35px;
    font-size:14px;
}
.img-size img{
	width: 80px;
    height: 80px;
}
</style><%-- 
<%
int pageSize = 10;
%> --%>
</head>
<body>
<% if(rs.next()){ %>
<div class="heading-section">
<div class="photo">
<img src="Sales.jpg">
</div>
<div class="heading-text">
<h1>Sales Records</h1>
<label>View And Manage All
	   Sales Records</label>
</div>
<form action="ViewSales.jsp" method="get">
    <input type="text"
           placeholder="Search By ProductName,CustomerName"
           name="product"
           id="prd"
           value="<%= product != null ? product : "" %>"
           >
    <button class="search" type="submit">
        Search
    </button>
        <button class="reset" type="reset" onClick="window.location.href='ViewSales.jsp'" >
        Reset
    </button>
</div>
</form>
<label class="tentries">Total Entries : <%= totalRecords %></label>
<table>
<tr>
    <th>SL No</th>
    <th></th>
    <th>Product Name</th>
    <th>Cost Price</th>
    <th>Price</th>
    <th>Sale Date</th>
    <th>Quantity</th>
    <th>Customer Name</th>
    <th>Doctor Name</th>
</tr>

<%
int slno=Start + 1;
%>
<%do{ %>
<tr>
<td><%= slno++ %></td>
<td><%
	PreparedStatement p = conn.prepareStatement(
	    "SELECT ID FROM PURCHASE WHERE PRODUCT_NAME = ?"
	);
	p.setString(1, rs.getString("PRODUCT_NAME"));
	ResultSet rp = p.executeQuery();
	%>
<form action="EditSales.jsp" method="get">
    <input type="hidden" name="id" value="<%=rs.getInt("ID")%>">
    <% if(rp.next()) { %>
        <input type="hidden" name="purid" value="<%=rp.getInt("ID")%>">
    <% } %>
    <button class="hello"><img src="Edit.jpg" style="width:30px;"></button>
</form>
<form method="post" action="DeleteSales">
<input type="hidden" name="product" value="<%= rs.getString("PRODUCT_NAME") %>">
<button class="hai" type="submit" onClick="return confirm('Are you sure you want to delete this Sale?')">
<img src="Delete.jpg" style="width:30px;">
</button>
</form>
</td>
<td><%= rs.getString("PRODUCT_NAME") %></td>
<td><%= rs.getFloat("COST_PRICE") %></td>
<td><%= rs.getFloat("PRICE") %></td>
<td><%= rs.getDate("SALE_DATE") %></td>
<td><%= rs.getFloat("QUANTITY") %></td>
<td><%= rs.getString("CUSTOMER_NAME") %></td>
<td><%= rs.getString("DOCTOR") %></td>
</tr>
<%}while(rs.next()); %>
</table>
<div class="navigation">
<div class="prev-btn">
<%if(currentPage > 1){
%>
<a href="ViewSales.jsp?page=<%= currentPage - 1 %>">
<button type="submit" class="nav-buttons">Previous</button>
</a>
<%}%>
</div>
<button class="label-style"><%=currentPage %></button>
<div class="next-btn">
<%
if(totalRecords > currentPage * recordsPage){
%>
<a href="ViewSales.jsp?page=<%= currentPage + 1 %>">
<button type="submit" class="nav-buttons">Next</button></a>
<% } %>
</div>
</div>
<%
}else{%>
<h2 style="text-align:center; margin-top:50px;">No data Found</h2>	
<a href="ViewSales.jsp"><
    <button class="back-btn">Back To Sales</button>
</a>
<% }%>
</body>
</html>

<%
}
catch(Exception e){
out.println("<h2>Error : " + e.getMessage() + "</h2>");
}
finally{
try{ if(rs!=null) rs.close(); }catch(Exception e){}
try{ if(ps!=null) ps.close(); }catch(Exception e){}
try{ if(conn!=null) conn.close(); }catch(Exception e){}
}
%>

