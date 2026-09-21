<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
int id = Integer.parseInt(request.getParameter("ID"));
try{
	Connection conn = DBConnection.getConnection();
	PreparedStatement ps = conn.prepareStatement("SELECT * FROM STOCKS WHERE S_ID = ? ");
	ps.setInt(1,id);
	ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

body{
    font-family:Arial,sans-serif;
}

.all{
    width:550px;
    margin:50px auto;
    padding:30px;
    border:5px solid black;
    border-radius:20px;
    background:white;
}

h1{
    text-align:center;
    font-size:50px;
}

.form-group{
    display:flex;
    align-items:center;
    margin:20px 0;
}

label{
    width:200px;
    font-size:20px;
}

input,
select{
    flex:1;
    padding:10px;
    font-size:16px;
    border-radius:5px;
}

.btn{
    text-align:center;
    margin-top:20px;
}

button{
    background:cornflowerblue;
    color:white;
    padding:12px 25px;
    font-size:18px;
    border:none;
    border-radius:6px;
    cursor:pointer;
}

button:hover{
    background:black;
}

</style>
</head>
<body>
<h1>Edit Stocks</h1>
<form action="EditStocks"  method="post">
<div class="all">
<%while(rs.next()){ %>
<input type="hidden" name="ID" value="<%= rs.getInt("S_ID") %>">
<div class="form-group">
<label>Product Name</label>
<input type="text" name="productName" value ="<%= rs.getString("PRODUCT_NAME") %>"required>
</div>

<div class="form-group">
<label>Quantity</label>
<input type="number" name="Quantity" value ="<%= rs.getInt("PRODUCT_QUANTITY") %>" required>
</div>

<div class="form-group">
<label>Purchase Date</label>
<input type="date" name="purhcaseDate" value ="<%= rs.getDate("PURCHASE_DATE") %>" required>
</div>

<div class="form-group">
<label>Manufacturing Date</label>
<input type="date" name="ManufacturingDate" value ="<%= rs.getDate("MANUFACTURING_DATE") %>" required>
</div>

<div class="form-group">
<label>Expiry Date</label>
<input type="date" name="ExpiryDate" value ="<%= rs.getDate("EXPIRY_DATE") %>">
</div>

<div class="form-group">
<label>Supplier Name</label>
<input type="text" name="supplierName" value ="<%= rs.getString("SUPPLIER_NAME") %>">
</div>

<div class="form-group">
<label>Rack No</label>
<input type="number" name="rackNo" value ="<%= rs.getInt("RACK_NO") %>" required>
</div>
<%} %>
<div class="btn">
<button type="submit">Submit</button>
</div>

</div>
</form>

</body>
</html>
<%
}catch(Exception e){
out.println("<h2>Error : " + e.getMessage() + "</h2>");
}
%>