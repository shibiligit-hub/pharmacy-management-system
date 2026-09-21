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
PreparedStatement ps1 = null;
ResultSet rs1 = null;
String product = request.getParameter("product");
try{

    conn = DBConnection.getConnection();
	if(product == null || product.trim().isEmpty()) {
    ps = conn.prepareStatement(
        "SELECT * FROM PURCHASE 	LIMIT ?,?"
    );
    ps.setInt(1,Start);
    ps.setInt(2,recordsPage);

    rs = ps.executeQuery();
	}else{
	ps = conn.prepareStatement("SELECT * FROM PURCHASE WHERE PRODUCT_NAME LIKE ? OR SUPPLIER_NAME LIKE ?");
    ps.setString(1, "%" + product + "%");
    ps.setString(2, "%" + product + "%");
	rs = ps.executeQuery();
	}
	PreparedStatement countps = conn.prepareStatement("SELECT COUNT(*) FROM PURCHASE");
	ResultSet rscount = countps.executeQuery();
	int totalRecords = 0;
	if(rscount.next()){
		totalRecords = rscount.getInt(1);
	}
%>
<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">
<title>View Purchase</title>

<style>

body{
    background-color:#F0F0F2;
    color:black;
    font-family:Arial,sans-serif;
    overflow-x:hidden;
    margin:0;
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
    width:100%;
    margin:auto;
    background:white;
    border-collapse:collapse;
    table-layout:auto;
    margin-top : 40px;
}

th{
	background-color:blue;
	color:white;
    font-size:22px;
    font-weight:600;
    text-align:left;
    padding:20px 35px;
	border: 1px solid black;    
    white-space:nowrap;
}

th{
    background-color:blue;
    color:white;
    font-size:18px;
    font-weight:600;
    text-align:left;
    padding:15px 10px;
    border:1px solid black;
}

td{
    font-size:16px;
    font-weight:400;
    text-align:left;
    padding:0px 20px;
    border:1px solid black;
}

tr:last-child td{
    border-bottom:none;
}

.jawad{
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
    	cursor: pointer;
    	gap:5px;
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
.label-style{
	padding:10px 20px;
    font-size:15px;
    border-radius:5px;
    cursor:pointer;
	display:block;
	margin:20px auto;
}
.jomon{
    padding:10px 20px;
    font-size:15px;
    cursor:pointer;
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
<img src="NewPurchase.jpg">
</div>
<div class="heading-text">
<h1>Purchase Records</h1>
<label>View And Manage All
	   Purchase Records</label>
</div>
<form action="ViewPurchase.jsp" method="get">
    <input type="text"
           placeholder="Search By ProductName,SupplierName"
           name="product"
           id="prd"
           value="<%= product != null ? product : "" %>">

    <button class="search" type="submit">
        Search
    </button>
        <button class="reset" type="reset" onclick="window.location.href='ViewPurchase.jsp'">
        Reset
    </button>
</div>

</form>
<table>	
<tr>

    <th>ID</th>
	<th>Actions</th>
    <th>Supplier Name</th>
    <th>Product Name</th>
    <th>Quantity</th>
    <th>Invoice Number</th>
    <th>Unit Price</th>
	<th>Total Price</th>	
    <th>Purchase Date</th>
	<th>Manufacturing Date</th>
    <th>Expiry Date</th>
</tr>
<%int slno = Start+1;
%>
<%do{ %>
<tr>	
	<td><%= slno++ %></td>
	    <td>
    		<form action="EditPurchase.jsp" method="get">
	    <input type="hidden" value="<%= rs.getInt("ID")%>" name="od" >
	    <input type="hidden" value="<%= rs.getString("SUPPLIER_NAME")%>" name="supplier">
    	    <button class="hello" type="submit" ><img src="Edit.jpg" style="width:30px;"></button>
    	    </form>
    		<form action="DeletePurchase" method="post">
    		<input type="hidden" value="<%= rs.getString("SUPPLIER_NAME") %>" name="supplier">
       	<button class="hai" type="submit" onClick="return confirm('Are you sure you want to delete this Purchase?')">
       	<img src="Delete.jpg" style="width:30px;">
		</button>
       	</form>
    </td>	
    <td>
        <%= rs.getString("SUPPLIER_NAME") %>
    </td>
    <td>
        <%= rs.getString("PRODUCT_NAME") %>
    </td>
    <td>
        <%= rs.getInt("QUANTITY") %>
    </td>
     <td>
        <%= rs.getInt("INVOICE") %>
    </td>   
    <td>
    		<%= rs.getDouble("UNIT_COST_PRICE") %>
    </td>
    <td>
        <%= rs.getFloat("PRICE") %>
    </td>
    <td>
        <%= rs.getDate("PURCHASE_DATE") %>
    </td> 
    <td>
        <%= rs.getDate("MANUFACTURING_DATE") %>
    </td>
    <td>
        <%= rs.getDate("EXPIRY_DATE") %>
    </td>
</tr>
<%}while(rs.next()); %>
</table>
<div class="navigation">
<div class="prev-btn">
<%if (currentPage > 1){ %>
<a href="ViewPurchase.jsp?page=<%= currentPage - 1 %>">
<button type="submit" class="nav-buttons">Previous</button>
</a>
<%} %>
</div>
<button class="jomon"><%=currentPage %></button>
<div class="next-btn">
<%if(totalRecords > currentPage * recordsPage){ %>
<a href="ViewPurchase.jsp?page=<%= currentPage + 1 %>">
<button type="submit" class="nav-buttons">Next</button>
</a>
<%}%>
</div>
</div>
<%
} else {
%>
<h2 style="text-align:center; margin-top:50px;">
    No Data Found
</h2>
<a href="ViewPurchase.jsp">

    <button class="back-btn">

        Back to Purchase
    </button>

</a>
<%
}
%>

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