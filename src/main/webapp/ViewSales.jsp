<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
int currentPage = 1;
int recordsPage = 5;
if(request.getParameter("page")!= null){
	currentPage = Integer.parseInt(request.getParameter("page"));
}
int Start = (currentPage - 1) * recordsPage;
String pharmaName = (String) session.getAttribute("pharma_name");

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
int totalPages = (int) Math.ceil((double) totalRecords / recordsPage);
PreparedStatement type = conn.prepareStatement("SELECT TYPE FROM LOGIN WHERE USERNAME = ?");
type.setString(1,pharmaName);
ResultSet rstype = type.executeQuery();
String res =null;
if(rstype.next()){
	res = rstype.getString("TYPE");
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
.boy{
	width:500px;
	height:35px;
	font-size:19px;
	margin-top:45px;
	margin-left:600px;
}
.tentries{	
	display: flex;
    margin-top: 35px;
    margin-left: 96px;
    font-size: 20px;
    font-weight: bold;
}
table {
	text-align:center;	
    width: 90%;
   	margin: 0 auto;
    table-layout: fixed;
    border-collapse: collapse;
    background-color:white;
}

th{
    background-color:blue;
    color:white;
    font-size:18px;
    font-weight:600;
    text-align:center;
    border:1px solid black;
    padding: 5px 3px;
}

td{
    font-size:13px;
    font-weight:400;
    padding:0px 20px;
    text-align:center;
    border:1px solid black;
    white-space:nowrap;
    overflow:hidden;
}
tr:last-child td{
    border-bottom:;
}
th:nth-child(1),
td:nth-child(1){
	width:35px;
	text-align:center;
}

th:nth-child(2),
td:nth-child(2){
	width:130px;
}

th:nth-child(4),
td:nth-child(4){
	width:100px;
}

th:nth-child(5),
td:nth-child(5){
	width:100px;
}

th:nth-child(2),
td:nth-child(2){
	width:130px;
}

.classtd{
    text-align:center;
    font-weight:500;
	border: 1px solid black;    
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
.diff input{
	width:100%;
	background-color:white;
	border:none;
    font-size:18px;
    font-weight:500;
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
    		   class="boy"
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
</form>
</div>
<label class="tentries">Total Entries : <%= totalRecords %></label>
<table>
<tr>
    <th>SL No</th>
    <%if("ADMIN".equals(res)){ %>
   	<th>Actions</th> 
   	<%} %>
   	<th>Product Name</th>
    <th>Cost Price</th>
    <th>Price</th>
    <th>Sale Date</th>
    <th>Quantity</th>
    <th>Supplier Name</th>
    <th>Company Name</th>
    <th>Customer Name</th>
    <th>Doctor Name</th>
</tr>

<%
int slno=Start + 1;
%>
<%do{ %>
<%if("ADMIN".equals(res)) {%>
<tr id="row<%=rs.getInt("ID") %>">
<td><%= slno++ %></td>
<td><%
	PreparedStatement p = conn.prepareStatement(
	    "SELECT ID FROM PURCHASE WHERE PRODUCT_NAME = ?"
	);
	p.setString(1, rs.getString("PRODUCT_NAME"));
	ResultSet rp = p.executeQuery();
	%>
    		<form id="<%=rs.getInt("ID") %>"action="EditSales" method="post">
    	    <button class="hello"  type="button" onclick="editRow(<%=rs.getInt("ID") %>)"><img src="Edit.jpg" style="width:30px;"></button>
    	    <input type="hidden" value="<%=rs.getInt("ID") %>" name="id">
    	    <button class="hello" type="submit" ><img src="H.png" style="width:30px;"></button>
    	   </form>
</td>
<td class="diff" id="one"><input type="text" name="productn" form="<%= rs.getInt("ID") %>" value="<%= rs.getString("PRODUCT_NAME") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="costp" form="<%= rs.getInt("ID") %>" value="<%= rs.getFloat("COST_PRICE") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="price" form="<%= rs.getInt("ID") %>" value="<%= rs.getFloat("PRICE") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="saled" form="<%= rs.getInt("ID") %>" value="<%= rs.getDate("SALE_DATE") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="quant" form="<%= rs.getInt("ID") %>" value="<%= rs.getFloat("QUANTITY") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="supp" form="<%= rs.getInt("ID") %>" value="<%= rs.getString("SUPPLIER") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="comp" form="<%= rs.getInt("ID") %>" value="<%= rs.getString("COMPANY_NAME") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="costmna" form="<%= rs.getInt("ID") %>" value="<%= rs.getString("CUSTOMER_NAME") %>" disabled></td>
<td class="diff" id="one"><input type="text" name="doct" form="<%= rs.getInt("ID") %>" value="<%= rs.getString("DOCTOR") %>" disabled></td>

</tr>
<%}else{ %>
<tr id="row<%= rs.getInt("ID") %>">
    <td class="classtd"><%= slno++ %></td> 
	<td class="classtd"><%= rs.getString("PRODUCT_NAME") %></td>
    <td class="classtd"><%= rs.getFloat("COST_PRICE") %></td> 
    <td class="classtd"><%= rs.getFloat("PRICE") %></td>
    <td class="classtd"><%= rs.getDate("SALE_DATE") %>"</td>
    <td class="classtd"><%= rs.getFloat("QUANTITY") %>"</td>
    <td class="classtd"><%= rs.getString("CUSTOMER_NAME") %></td>
    <td class="classtd"><%= rs.getString("DOCTOR") %></td>
</tr>
<%} %>
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
<input type="text" id="inpval" class="button-style" value="<%= currentPage %>" onchange="changing()">
<%
if(totalRecords > currentPage * recordsPage){
%>
<div class="next-btn">
<a href="ViewSales.jsp?page=<%= currentPage + 1 %>">
<button type="submit" class="nav-buttons">Next</button></a>
<% } %>
</div>
</div>
<%
}else{%>
<h2 style="text-align:center; margin-top:50px;">No Sale data Found</h2>	
<a href="ViewSales.jsp">
    <button class="back-btn">Back To Sales</button>
</a>
<% }%>
<script>
let editingrow = null;
function editRow(id){
	
	if(editingrow != null){
		let previousrow = document.getElementById("row" + editingrow);
		let previousInputs = previousrow.querySelectorAll("input[type='text']");
			previousInputs.forEach(input =>{input.disabled = true;});
	}
	
	
	let row = document.getElementById("row" + id);
	let inputs = row.querySelectorAll("input[type='text']");
	inputs.forEach(input =>{input.disabled = false;});
	editingrow = id;

}
function changing(){
	let inpv = document.getElementById("inpval").value;
	let totalPages = <%= totalPages %>;
	if(inpv <= totalPages){
	window.location.href="ViewSales.jsp?page=" + inpv;
	}else{
		alert("No Pages Found");
		let inpv = document.getElementById("inpval").value = 1;
		window.location.href="ViewSales.jsp?page=" + inpv;
	}
}
</script>
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

