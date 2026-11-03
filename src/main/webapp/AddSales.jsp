<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
Connection conn = null;
PreparedStatement ps = null;
PreparedStatement ps1 = null;
PreparedStatement ps2 = null;
PreparedStatement ps8 = null;
PreparedStatement ps11 = null;
PreparedStatement invoi = null;
PreparedStatement pname = null;

ResultSet rname = null;
ResultSet rs = null;
ResultSet rs1 = null;
ResultSet rs2 = null;
ResultSet inv = null;

String product = request.getParameter("product");
String barcode = request.getParameter("barcode");
String stockId = request.getParameter("stockId");
String cname = "";
String dname = "";

try {

    conn = DBConnection.getConnection();
    ps = conn.prepareStatement(
    	    "SELECT DISTINCT S_ID,PRODUCT_NAME FROM STOCKS WHERE PRODUCT_QUANTITY > 0"
    );
    rs = ps.executeQuery();
    
    pname = conn.prepareStatement("SELECT PRODUCT_NAME FROM STOCKS WHERE S_ID = ?");
    pname.setString(1, stockId);
    rname = pname.executeQuery();
    if(rname.next()){
    		product = rname.getString("PRODUCT_NAME");
    }
    
    ps11 = conn.prepareStatement("DELETE FROM PURCHASE WHERE QUANTITY <= 0");
    ps11.executeUpdate();
    
	ps8 = conn.prepareStatement("SELECT PATIENT_NAME,DOCTOR_NAME FROM SALES_TP LIMIT 1");
	
	ResultSet rs8 = ps8.executeQuery();
	if(rs8.next()){
		cname = rs8.getString("PATIENT_NAME");
		dname = rs8.getString("DOCTOR_NAME");
	}
	
    if (stockId != null && !stockId.trim().isEmpty()) {

        ps1 = conn.prepareStatement(
            "SELECT PRODUCT_QUANTITY FROM STOCKS WHERE S_ID=?"
        );
        ps1.setInt(1, Integer.parseInt(stockId));
        rs1 = ps1.executeQuery();

        ps2 = conn.prepareStatement(
            "SELECT UNIT_COST_PRICE FROM PURCHASE WHERE PRODUCT_NAME=?"
        );
        ps2.setString(1, product);
        rs2 = ps2.executeQuery();
        
        invoi = conn.prepareStatement(
            "SELECT INVOICE FROM PURCHASE WHERE PRODUCT_NAME=?"
        );
        invoi.setString(1, product);
        inv = invoi.executeQuery();
    }else{
    		ps1 = conn.prepareStatement(
             "SELECT PRODUCT_QUANTITY FROM STOCKS WHERE PRODUCT_NAME=?"
        );
        ps1.setString(1, product);
        rs1 = ps1.executeQuery();

        ps2 = conn.prepareStatement(
                "SELECT UNIT_COST_PRICE FROM PURCHASE WHERE PRODUCT_NAME=?"
        );
        ps2.setString(1, product);
        rs2 = ps2.executeQuery();

        invoi = conn.prepareStatement(
                "SELECT INVOICE FROM PURCHASE WHERE PRODUCT_NAME=?"
        );
        invoi.setString(1, product);
        inv = invoi.executeQuery();
    }
    PreparedStatement psg = conn.prepareStatement("SELECT COUNT(PRODUCT_NAME) FROM STOCKS");
    	ResultSet rsg = psg.executeQuery();
    	PreparedStatement supp = null;
    	ResultSet suppre = null;
    	if(stockId != null && !stockId.trim().isEmpty()) {
         supp = conn.prepareStatement("SELECT SUPPLIER_NAME,COMPANY_NAME FROM STOCKS WHERE S_ID = ?");
        supp.setInt(1,Integer.parseInt(stockId));
        suppre = supp.executeQuery();
    	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Sales</title>	
<style>
body{
    font-family:Arial,sans-serif;
}
.all{
    width:550px;
    margin:20px auto;
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
    display: flex;
    justify-content: center;
    gap: 40px;    
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
table{
    width:95%;
    margin:auto;
    border-collapse:collapse;
    background:white;
}

th{
    font-size:18px;
    font-weight:600;
    text-align:left;
    padding:20px 40px;
    border-bottom:1px solid #ddd;
    color:black;
}

td{
    font-size:16px;
    font-weight:400;
    text-align:left;
    padding:20px 40px;
    border-bottom:1px solid #eee;
    color:black;
}

tr:last-child td{
    border-bottom:none;
}

button:hover{
    background:black;
}
</style>

<script>
function Calc(){

    let unit =
        parseFloat(document.getElementById("uni").value) || 0;

    let qty =
        parseFloat(document.getElementById("qtyi").value) || 0;

    document.getElementById("pricer").value = unit * qty;
}
</script>

</head>

<body>

<h1>Add Sales</h1>

<div class="all">

<form method="post"> 

    <div class="form-group">
        <label>Product Name</label>

<select name="product"
        onchange="window.location='AddSales.jsp?stockId='+this.value">
    <option value="">Select Product</option>

    <% while(rs.next()) { %>
        <option value="<%= rs.getInt("S_ID") %>"
        <%=stockId!= null && stockId.equals(String.valueOf(rs.getInt("S_ID"))) ? "selected " : "" %>>
            <%= rs.getString("PRODUCT_NAME") %>
        </option>
    <% } %>
</select>

    </div>

    <% if(rs1 != null && rs1.next()) { %>

    <div class="form-group">
        <label>Available Quantity</label>

        <input
            type="number"
            id="availableQty"
            value="<%= rs1.getDouble("PRODUCT_QUANTITY") %>"
            readonly>
    </div>

    <% } %>

    <div class="form-group">
        <label>Quantity</label>

        <input
            type="number"
            id="qtyi"
            name="qty"
            onkeyup="Calc();checking();"
            required>
    </div>

    <%
    Double unitPrice = null;

    if(rs2 != null && rs2.next()){
        unitPrice = rs2.getDouble("UNIT_COST_PRICE");
    }
    %>

    <div class="form-group">
        <label>Unit Price</label>

        <input
            type="number"
            id="uni"
            name="cprice"
            value="<%= unitPrice != null ? unitPrice : "" %>"
            readonly>
    </div>

    <div class="form-group">
        <label>Total Price</label>

        <input
            type="number"
            id="pricer"
            name="price"
            readonly>
    </div>

    <% if(stockId != null && inv.next()) { %>

    <div class="form-group">
        <label>Invoice Number</label>

        <input
            type="number"
            name="inv"
            value="<%= inv.getInt("INVOICE") %>"
            readonly>
    </div>

    <% } %>

<%if(stockId != null){while(suppre.next()){ %>
    <div class="form-group">
        <label>Supplier Name</label>

        <input
            type="text"
            name="sname"
            id="snmae"
            value="<%=suppre.getString("SUPPLIER_NAME") %>"
	       	required>
    </div>
   
     <div class="form-group">
        <label>Company Name</label>

        <input
            type="text"
            name="company"
            id="company"
            value="<%=suppre.getString("COMPANY_NAME") %>"
	       	required>
    </div>
<%} }%>

    <div class="form-group">
        <label>Customer Name</label>

        <input
            type="text"
            name="cname"
            id = "cname"
            value="<%=cname %>"
            required>
    </div>
    
    <div class="form-group">
        <label>Doctor Name</label>

        <input
            type="text"
            name="dname"
            id = "dname"
            value="<%=dname %>"
            required>
    </div>
    <div class="btn">
    <%int count = 0;%>
    <% if(rsg.next()){
    		count = rsg.getInt(1);
    }
    if(count > 1){
    	%>
	<button type="submit"
        formaction="Addmore"
        style="background-color:#556b2f">
    AddMore
	</button>
<%} %>
	<button type="submit"
        formaction="AddSales">
    Submit
	</button>
    </div>
</form>

</div>
<%
PreparedStatement ps7 = null;
ResultSet rs7 = null;

ps7 = conn.prepareStatement("SELECT * FROM SALES_TP");
rs7 = ps7.executeQuery();

if(rs7.next()){
%>
<table>
<tr>
<th>Product Name</th>
<th>Quantity</th>
<th>Unit Price</th>
<th>Price</th>
</tr>
<%do{ %>
<tr>
<td><%= rs7.getString("PRODUCT_NAME") %></td>
<td><%= rs7.getDouble("QUANTITY") %></td>
<td><%= rs7.getDouble("UNIT_PRICE") %></td>
<td><%= rs7.getDouble("PRICE") %></td>

</tr>
<%}while(rs7.next()); %>
<% } %>
</table>
<script>
function checking(){
	let avaiqnty = parseFloat(document.getElementById("availableQty").value);
	let inpqty = parseFloat(document.getElementById("qtyi").value);
	if(inpqty <=0 || inpqty > avaiqnty ){
		alert("Insufficient Quantity");
		document.getElementById("qtyi").value=" ";
		document.getElementById("pricer").value=" ";
	}
}
</script>
</body>
</html>

<%
}
catch(Exception e){
    e.printStackTrace();
    out.println("<h3>Error : " + e.getMessage() + "</h3>");
}
%>
