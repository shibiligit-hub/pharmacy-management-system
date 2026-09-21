<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
PreparedStatement ps1 = null;
ResultSet rs1 = null;
PreparedStatement ps2 = null;
ResultSet rs2 = null;
int id = Integer.parseInt(request.getParameter("od"));

try{	
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT * FROM PURCHASE WHERE ID = ?");
	ps.setInt(1,id);
	rs = ps.executeQuery();
	rs.next();

	String supplier = request.getParameter("supplier");

	if(supplier == null || supplier.trim().isEmpty()) {
	    supplier = rs.getString("SUPPLIER_NAME");
	}
	
	ps1 = conn.prepareStatement(
		    "SELECT DISTINCT SUPPLIER_NAME " +
		    	    "FROM PURCHASE " +
		    	    "WHERE SUPPLIER_NAME IS NOT NULL"		);
		rs1 = ps1.executeQuery();
	
		ps2 = conn.prepareStatement(
			    "SELECT PRODUCT_NAME, COMPANY_NAME,INVOICE,QUANTITY,UNIT_COST_PRICE,PRICE " +
			    "FROM PURCHASE WHERE SUPPLIER_NAME = ?"
			);

			ps2.setString(1, supplier);

			rs2 = ps2.executeQuery();

			String company_name = "";
			String product_name = "";
			int invoice = 0;
			int quantity = 0;
			float price = 0;
			double unit_price = 0.0;
			
			if(rs2.next()){
			    company_name = rs2.getString("COMPANY_NAME");
			    product_name = rs2.getString("PRODUCT_NAME");
			    invoice = rs2.getInt("INVOICE");
			    quantity = rs2.getInt("QUANTITY");
			    price = rs2.getFloat("PRICE");
			    unit_price = rs2.getDouble("UNIT_COST_PRICE");
			}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Edit Sales</title>

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
<script>

function calculateTotal(){

		let qty = document.getElementById('qua').value;
		let uprice = document.getElementById('upri').value;	
		let total = qty * uprice;
		document.getElementById('total').value= total;
}

</script>
</head>
<script>
function changeProduct(supplier){

    window.location.href =
        "EditPurchase.jsp?od=<%=id%>&supplier="
        + encodeURIComponent(supplier);

}
</script>
<body>
<form action="EditPurchase" method="Post">
<h1>Edit Purchase</h1>

<input type="hidden" name="od" value="<%= id %>">
<div class="all">


    <div class="form-group">
        <label>Supplier Name</label>

        <select name="supplier" onchange="changeProduct(this.value)">

            <%

            while(rs1.next()){
                String supplierName = rs1.getString("SUPPLIER_NAME");
            %>

            <option value="<%= supplierName %>"
                <%= supplierName.equals(supplier) ? "selected" : "" %>>
                <%= supplierName %>
            </option>

            <%
            }
            %>

        </select>
    </div>


<div class="form-group">
<label>Company Name</label>
<input type="text" name="companynam" id="company" value="<%=company_name  %>" readOnly>
</div>

<div class="form-group">
<label>Product Name</label>
<input type="text" name="product" id="product" value="<%= product_name %>" readOnly>
</div>
<div class="form-group">
<label>Quantity</label>
<input type="number" name="phone" id="qua" value="<%=quantity %>" onkeyup="calculateTotal()" >
</div>

<div class="form-group">
<label>Unit Cost Price</label>
<input type="number" name="unit" id="upri" value="<%=unit_price%>" onkeyup="calculateTotal()" >
</div>


<div class="form-group">
<label>Total Price</label>
<input type="number" name="gstnu" id="total" value="<%=price %>" readonly>
</div>

<div class="form-group">
<label>Purchase Date</label>
<input type="date" name="pdate" value="<%= rs.getDate("PURCHASE_DATE") %>" required>
</div>

<div class="form-group">
<label>Manufacturing Date</label>
<input type="date" name="mdate" value="<%= rs.getDate("MANUFACTURING_DATE")%>" required>
</div>

<div class="form-group">
<label>Expiry Date</label>
<input type="date" name="edate" value="<%= rs.getDate("EXPIRY_DATE") %>" required>
</div>

<div class="form-group">
<label>Invoice Number</label>
<input type="number" name="invno" value="<%=invoice %>" required>
</div>


<div class="btn">
<button type="submit">Edit</button>
</div>

</div>
</form>

</body>

</html>

<%
}catch(Exception e){

    out.println(
        "<h2>Error : " + e.getMessage() + "</h2>"
    );

}
%>