<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
Connection conn=null;
PreparedStatement ps = null;
ResultSet rs = null;
int id = Integer.parseInt(request.getParameter("id"));
try{
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT * FROM SUPPLIER WHERE SUPP_ID = ?");
	ps.setInt(1,id);
	rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Supplier</title>

<style>
body{
	background-color:#F0F0F2;
    font-family:Arial,sans-serif;
}

.all{
	background-color:white;
    width: 550px;               
    margin: 100px auto;
    padding: 30px;               
    color:black;
	border-radius:20px;
}
.all{
    border:5px solid black !important;
}

.form-group{
    display: flex;
    align-items: center;	
    margin: 20px 0;             
}

label{
    width: 200px;               
    font-size: 20px;            
}

input{
	background-color:white;
    flex: 1;
    padding: 10px;               
    font-size: 16px;
    border-radius: 5px;
}

.btn{
    text-align: center;
    margin-top: 25px;
}

button{
    padding: 12px 25px;          
    font-size: 18px;
    border-radius: 6px;
    cursor: pointer;
    background-color: cornflowerblue;
    	color:white;
}

h1{
    text-align: center;
    font-size:50px;              
}
</style>
</head>

<body>

<form action="EditSupplier" method="Post">
<% if(rs.next()){ %>
<input type="hidden" name="id" value="<%= rs.getInt("SUPP_ID") %>">
<h1>Edit Supplier</h1>

<div class="all">

<div class="form-group">
<label>Supplier Name</label>
<input type="text" name="supplierna" value = "<%=rs.getString("SUPPLIER_NAME") %>" required>
</div>

<div class="form-group">
<label>Product Name</label>
<input type="text" name="product" value = "<%=rs.getString("PRODUCT_NAME") %>" required>
</div>

<div class="form-group">
<label>Company Name</label>
<input type="text" name="companynam" value = "<%=rs.getString("COMPANY_NAME") %>" required>
</div>

<div class="form-group">
<label>Phone</label>
<input type="tel" name="phone" value = "<%=rs.getString("PHONE") %>" required>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" name="email" value = "<%=rs.getString("EMAIL") %>" required pattern="[a-zA-Z0-9._%+-]+@gmail\.com"
title="Please enter a valid @gmail.com address">
</div>


<div class="form-group">
<label>Gst No</label>
<input type="number" name="gstnu" value = "<%=rs.getString("GST_NUMBER") %>" required>
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

    out.println(
        "<h2>Error : " + e.getMessage() + "</h2>");
}
%>