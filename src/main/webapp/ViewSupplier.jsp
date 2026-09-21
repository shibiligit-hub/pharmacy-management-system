<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if(session.getAttribute("pharma_name") == null){
    response.sendRedirect("Login.jsp");
    return;
}
%>
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
String company = request.getParameter("company");
String supplier = request.getParameter("company");

try{
	conn = DBConnection.getConnection();
	if(company == null || company.trim().isEmpty()){
		ps = conn.prepareStatement("SELECT * FROM SUPPLIER LIMIT ?,?");
		ps.setInt(1,Start);
		ps.setInt(2,recordsPage);
		rs = ps.executeQuery();
	}else{
		ps = conn.prepareStatement("SELECT * FROM SUPPLIER WHERE COMPANY_NAME LIKE ? OR "
				+"SUPPLIER_NAME LIKE ?");
		ps.setString(1,"%" + "%" + company);
		ps.setString(2,"%" + "%" + supplier);
		rs = ps.executeQuery();
	}
	PreparedStatement ps10 = conn.prepareStatement("SELECT COUNT(*) FROM SUPPLIER");
	ResultSet rs10 = ps10.executeQuery();
	int totalRecords = 0;
	if(rs10.next()){
		totalRecords = rs10.getInt(1);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Supplier</title>
<style>
body{
    background-color:#F0F0F2;
    color:black;
    font-family:Arial,sans-serif;
    margin:0;
    overflow-x:hidden;
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
	margin-top:35px;
}

input[type="text"]{
	width:500px;
	height:35px;
	font-size:19px;
	margin-top:90px;
	margin-left:600px;
}


table{
    width:95%;
    margin:auto;
    background:white;
    border-collapse:collapse;
    margin-top:40px;	
}

th{
	background-color:blue;
	color:white;
	border: 1px solid black;    
    font-size:22px;
    font-weight:600;
    text-align:left;
    padding:20px 35px;
    border-bottom:3px solid #ddd;
    white-space:nowrap;
}

td{
    font-size:18px;
    font-weight:400;
    text-align:left;
    padding:0px 20px;
	border: 1px solid black;    
	white-space:nowrap;
}

tr:last-child td{
    border-bottom:2px;
}
.back-btn{
    display:block;
    margin:30px auto;
}
.hello{
	margin-top: 8px;
	background-color: White;
	color: white;
    width: 80px;
    	height: 40px;
    	font-size: 18px;
    	border: none;
    	border-radius: 5px;
    	cursor: pointer;		gap:5px;
}
td:last-child {
    text-align: center;
    white-space: nowrap;
}
.hai{
	margin-top: 8px;
    background-color: White;
    color: white;
    width: 80px;
    height: 40px;
    font-size: 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
.search{
    padding:10px 20px;
    font-size:15px;
    border:none;
    border-radius:5px;
    cursor:pointer;
    width: 115px;
    background-color: #315BEA;
    height: 40px;
    color: white;
    font-size:19px;
}
.reset{
    padding:10px 20px;
    font-size:15px;
    border:none;
    border-radius:5px;
    cursor:pointer;
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
    margin-top: 60px;
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
.img-size img{
	width: 80px;
    height: 80px;
}
</style>

</head>
<body>
<%
if(rs.next()){
%>
<div class="heading-section">
<div class="photo">
<img src="Supplier.jpg">
</div>
<div class="heading-text">
<h1>Supplier Records</h1>
<label>View And Manage All
	   Supplier Records</label>
</div>
<form action="ViewSupplier.jsp" method="get">
    <input type="text"
           placeholder="Search By SupplierName,CompanyName"
           name="company"
           >
    <button class="search" type="submit" onClick="">
        Search
    </button>
    <button class="reset" type="reset" onClick = "window.location.href='ViewSupplier.jsp'">
    		Reset
    </button>
</div>
</form>

<table>
<tr>
    <th>ID</th>
   	<th>Actions</th> 
    <th>Supplier Name</th>
    <th>Company Name</th>
    <th>Product Name</th>
    <th>Phone</th>
    <th>Email</th>
    <th>GST No</th>
</tr>

<%
int slno=Start+1;
do{
%>	
<tr>
    <td><%= slno++ %></td>
    <td>
    <form action="EditSupplier.jsp" method="get">
    <input type="hidden" value="<%= rs.getInt("SUPP_ID") %>" name="id">
    <button class="hello" type="submit"><img src="Edit.jpg" style="width:30px;"></button>
    </form>
    <form action="DeleteSupplier" method="post">
    <input type="hidden" value="<%= rs.getString("SUPPLIER_NAME") %>" name="supplier">
    <button class="hai" type="Submit" onClick="return confirm('Are you sure you want to delete this Supplier?')">
    <img src="Delete.jpg" style="width:30px;">
    </button>
    </form>
    </td>
    <td><%= rs.getString("SUPPLIER_NAME") %></td>
    <td><%= rs.getString("COMPANY_NAME") %></td> 
    <td><%= rs.getString("PRODUCT_NAME") %></td>
    <td><%= rs.getString("PHONE") %></td>
    <td><%= rs.getString("EMAIL") %></td>
    <td><%= rs.getString("GST_NUMBER") %></td>
</tr>
<%}while(rs.next()); %>
</table>
<div class="navigation">
<div class="prev-btn">
<%if(currentPage > 1){
%>
<a href="ViewSupplier.jsp?page=<%= currentPage - 1 %>">
<button type="submit" class="nav-buttons">Previous</button>
</a>
<%}%>
</div>
<button class="label-style"><%=currentPage %></button>
<div class="next-btn">
<%
if(totalRecords > currentPage * recordsPage){
%>
<a href="ViewSupplier.jsp?page=<%= currentPage + 1 %>">
<button type="submit" class="nav-buttons">Next</button></a>
<% } %>
</div>
</div>
<%}else{ %>
<h2 style="text-align:center; margin-top:50px;">No Data Found</h2>
<a href="ViewSupplier.jsp">
    <button class="back-btn">Back To Supplier</button>
</a>
<%} %>
<%
}
catch(Exception e){
%>

<h3>colspan="8">Error: <%= e.getMessage() %></h3> 


<%
}
finally{
try{ if(rs!=null) rs.close(); }catch(Exception e){}
try{ if(ps!=null) ps.close(); }catch(Exception e){}
try{ if(conn!=null) conn.close(); }catch(Exception e){}
}
%>
</body>
</html>
