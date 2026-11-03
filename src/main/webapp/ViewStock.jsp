<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@  page import="java.time.LocalDate" %>
<%
int recordsPage = 5;
int currentPage = 1;
LocalDate today = LocalDate.now();
if(request.getParameter("page")!= null){
	currentPage = Integer.parseInt(request.getParameter("page"));
}
int start = (currentPage - 1) * recordsPage;
%>
<%
Connection conn = null;
PreparedStatement ps = null;
PreparedStatement ps1 = null;
ResultSet rs = null;
ResultSet rs1 = null;
PreparedStatement rac = null;
ResultSet rack = null;
String product = request.getParameter("product");
try{
	conn = DBConnection.getConnection();
	if(product == null || product.isEmpty()){
		ps = conn.prepareStatement("SELECT * FROM STOCKS WHERE PRODUCT_QUANTITY > 0 LIMIT ?,?");
		ps.setInt(1,start);
		ps.setInt(2,recordsPage);
		ps1 = conn.prepareStatement("DELETE FROM STOCKS WHERE PRODUCT_QUANTITY <= 0");
		rs = ps.executeQuery();
		ps1.executeUpdate();		
	}else{
		ps = conn.prepareStatement("SELECT * FROM STOCKS WHERE PRODUCT_NAME LIKE ?");	
		ps.setString(1,"%" + product + "%");
		rs = ps.executeQuery();
	}
	PreparedStatement countt = conn.prepareStatement("SELECT COUNT(*) FROM STOCKS");
	ResultSet escount = countt.executeQuery();
	int totalRecords = 0;
if(escount.next()){
	totalRecords = escount.getInt(1);
}
int totalPages = (int) Math.ceil((double) totalRecords / recordsPage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
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
.tentries{	
	display: flex;
    margin-top: 35px;
    margin-left: 120px;
    font-size: 20px;
    font-weight: bold;
}
.photo img{
	width: 80px;
    height: 80px;
    object-fit: contain;
    margin-top: 37px;
}
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
    text-align:center;
    padding:20px 35px;
    font-weight:500;
    font-size:18px;    
	border: 1px solid black;    
}
.hello{
	margin-top: 8px;
	background-color: White;
    width: 80px;
    	height: 40px;
    	font-size: 18px;
    	border: none;
    	border-radius: 5px;
    	cursor: pointer;
    	gap:5px;
}
.back-btn{
	display:block;
    margin:20px auto;
}
.typtex{
	width:500px;
	height:35px;
	font-size:19px;
	margin-top:45px;
	margin-left:600px;
}
td:last-child {
    text-align: center;
    white-space: nowrap;
}
.hai{
	margin-top: 8px;
    background-color: white;
    width: 80px;
    height: 40px;
    font-size: 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
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
.navigation{
    width:95%;
    margin:20px auto;
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
}
.prev-btn{
	margin-left: 56px;
}
.next-btn{
    justify-self:end;
    margin-right:75px;
}

.nav-buttons{
    background-color:blue;
    color:white;
    width:83px;
    height:35px;
    font-size:14px;
}
.button-style{
	padding:10px 20px;
    border-radius: 5px;
    cursor: pointer;
    display: block;
    margin: 20px auto;
    font-size: 19px;
    width: 10px;
    height: 20px;
}
.label-style{
}
</style>
</head>
<body>
<% 
int count = 0;
if(rs.next()){
	count++;
%>
<div class="heading-section">
<div class="photo">
<img src="Stocks.jpg">
</div>
<div class="heading-text">
<h1 class="h1">STOCKS Records</h1>
<label>View and Manage All Stocks</label>
</div>
<form action="ViewStock.jsp" method="get">
<input type="text" placeholder='search by productName'
name="product" id="stk" class="typtex" value="<%= product != null ? product : "" %>">
<button class="search" type="submit">Search</button>
<button class="reset" type="reset" onClick="window.location.href='ViewStock.jsp'">Reset</button>
</form>
</div>
<label class="tentries">Total Entries : <%= totalRecords %></label>
<table>
<tr>
<th>SL No</th>
<th>Product Name</th>
<th>Quantity</th>
<th>Purchase Date</th>
<th>Manfacturing Date</th>
<th>Expiry Date</th>
<th>Supplier Name</th>
<th>Company Name</th>
<th>Rack No</th>
<th>Barcode</th>
</tr>
<%int slno= start+1;
 %>
<%do{ %>
<tr>
<td><%= slno++%></td>
<% 
Date exp = Date.valueOf(rs.getString("EXPIRY_DATE"));
LocalDate expdate = exp.toLocalDate();%>
<% LocalDate monthexpiry = today.plusMonths(1); 
   LocalDate tendayBefore = today.plusDays(10);
%>
<td><%= rs.getString("PRODUCT_NAME") %></td>
<td><%= rs.getString("PRODUCT_QUANTITY") %></td>
<td><%= rs.getString("PURCHASE_DATE") %></td>
<td><%= rs.getString("MANUFACTURING_DATE") %></td>
	<% if(expdate.isBefore(today)){ %>
		<td style="background-color:red; color:white;">Expired</td>
	<%}else if(!expdate.isAfter(monthexpiry)){ %>
		<td style="background-color:yellow; color:black;"><%=expdate %></td>
	<%}else if(!expdate.isEqual(today) && !expdate.isAfter(tendayBefore)){ %>
		<td style="background-color:red; color:white;"><%=expdate %></td>
	<%}else{ %>
		<td><%=exp %></td>
	<%} %>
<td><%= rs.getString("SUPPLIER_NAME") %></td>
<td><%= rs.getString("COMPANY_NAME") %></td>
<td><%= rs.getString("RACK_NO") %></td>
<td><%=	rs.getString("BARCODE") %></td>
</tr>
<%}while(rs.next());%>
</table>
<div class="navigation">
<div class="prev-btn">
<%if(currentPage > 1){ %>
<a href="ViewStock.jsp?page=<%= currentPage - 1 %>">
<button type="submit" class="nav-buttons">Previous</button>
</a>
<%} %>
</div>
<input type="text" id="inpval" class="button-style" value="<%= currentPage %>" onchange="changing()">
<%
if(totalRecords > currentPage * recordsPage){
%>
<div class="next-btn">
<a href="ViewStock.jsp?page=<%= currentPage + 1 %>">
<button type="submit" class="nav-buttons">Next</button></a>
<% } %>
</div>
<%
}else{
%>
<h2 style="text-align:center; margin-top:50px;">
    No Stock Data Found
</h2>
<a href="ViewStock.jsp">
    <button class="back-btn" >
        Back to Stocks
    </button>
</a>
<%}%>
</div>
<script>
function changing(){
	let inpv = document.getElementById("inpval").value;
	let totalPages = <%= totalPages %>;
	if(inpv <= totalPages){
	window.location.href="ViewStock.jsp?page=" + inpv;
	}else{
		alert("No Pages Found");
		let inpv = document.getElementById("inpval").value = 1;
		window.location.href="ViewStock.jsp?page=" + inpv;
	}
}
</script>
</body>
</html>
<%
}catch(Exception e){
out.println("<h2>Error : " + e.getMessage() + "</h2>");
}
finally{
try{ if(rs!=null) rs.close(); }catch(Exception e){}
try{ if(ps!=null) ps.close(); }catch(Exception e){}
try{ if(conn!=null) conn.close(); }catch(Exception e){}
}
%>
