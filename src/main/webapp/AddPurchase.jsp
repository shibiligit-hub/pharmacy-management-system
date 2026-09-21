<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@ page import="java.time.LocalDate" %>

<%

Connection conn = null;

PreparedStatement ps = null;
PreparedStatement ps2 = null;
PreparedStatement ps3 = null;
PreparedStatement ps5 = null;

ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs4 = null;
ResultSet rs3 = null;

String company = "";
String product = "";
String suppliername = request.getParameter("supplier");
try{

    conn = DBConnection.getConnection();

	
    ps = conn.prepareStatement(
        "SELECT * FROM SUPPLIER"
    );

    rs = ps.executeQuery();
	ps5 = conn.prepareStatement("SELECT PRODUCT_NAME FROM SUPPLIER WHERE SUPPLIER_NAME=?");
	ps5.setString(1,suppliername);
	
	rs4 = ps5.executeQuery();
	
			
    String suppid =
        request.getParameter("supplier");


    if(suppid != null){

        ps2 = conn.prepareStatement(
        "SELECT COMPANY_NAME FROM SUPPLIER WHERE SUPPLIER_NAME=?"
        );

        ps2.setString(1, suppid);

        rs2 = ps2.executeQuery();

        
        if(rs2.next()){

            company =
            rs2.getString("COMPANY_NAME");
        }
    }
    if(suppid != null){
    		ps3 = conn.prepareStatement(
    				"SELECT PRODUCT_NAME FROM SUPPLIER WHERE SUPPLIER_NAME=?"
    				);
    		ps3.setString(1,suppid);
    		rs3 = ps3.executeQuery();
            if(rs3.next()){

                product =
                rs3.getString("PRODUCT_NAME");
            }
    }


%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Add Purchase</title>

<style>

body{
	background-color:#F0F0F2;
    color:black;
    font-family:Arial,sans-serif;
    margin:0;
    padding:0;
}

h1{
    text-align:center;
    font-size:45px;
    margin-top:40px;
}

.form-box{

    display:flex;
	background-color:white;
    flex-direction:column;

    gap:18px;

    width: 550px;               

    margin:60px auto;

    padding:30px;
	border:5px solid black !important;
	
    border-radius:12px;
    }
.form-group{
    display:flex;
    align-items:center;
}

label{
    width:180px;
    font-size:18px;
}

.form-group input,
.form-group select{
    width:380px;
    height:42px;
    padding:10px;
    font-size:15px;
    border-radius:6px;
    box-sizing:border-box;
}
input[type="date"]{
	width:380px;
}

button{
	text-align:center;
    margin-top: 19px;
    padding: 13px;
    font-size: 18px;
    border-radius: 6px;
    cursor: pointer;
    width: 162px;
    height: 49px;
    	color:white;
    margin-left: 200px;
    background-color: cornflowerblue;
}

</style>

</head>

<body>



<form action="AddPurchase.jsp"
      method="post">

<h1>Add Purchase</h1>

<div class="form-box">


    <div class="form-group">

        <label>Supplier Name</label>

        <select name="supplier"
                onchange="this.form.submit()">

            <option value="">

                Select Supplier

            </option>

            <% while(rs.next()){ %>

            <option
            value="<%= rs.getString("SUPPLIER_NAME") %>"

            <% if(
            suppid != null &&
            suppid.equals(
            rs.getString("SUPPLIER_NAME"))
            ){ %>

                selected

            <% } %>
            >

            <%= rs.getString("SUPPLIER_NAME") %>

            </option>

            <% } %>

        </select>

    </div>



    <div class="form-group">

        <label>Company Name</label>

        <input type="text"
               name="company"
               value="<%= company %>"
               readonly>

    </div>

    <div class="form-group">

        <label>Product Name</label>
		<select name="product">
		<% while (rs4.next()){ %>
		<option value="<%=rs4.getString("PRODUCT_NAME")%>"><%=rs4.getString("PRODUCT_NAME") %></option>
		<%} %>
		</select>	
    </div>


    <div class="form-group">

        <label>Quantity</label>

        <input type="number"
        		   id="qua"
               name="quantity"
               onkeyup = "Calculate()"
               required>

    </div>


    <div class="form-group">

        <label>Unit Cost Price</label>

        <input type="number"
        			id="upri"   
 				name="Uprice"
 				onkeyup = "Calculate()"
               	required>

    </div>

    <div class="form-group">

        <label>Total Price</label>

        <input type="number"
        		   id="total"
               name="price"
               readonly>

    </div>
    <div class="form-group">

        <label class="new">Purchase Date</label>

        <input type="date"
               name="pdate"
               value="<%= LocalDate.now() %>"
               readOnly>

    </div>


    <div class="form-group">

        <label class="new">Manufacturing Date</label>

        <input type="date"
               name="pdate"
               required>

    </div>



    <div class="form-group">

        <label class="new">Expiry Date</label>

        <input type="date"
               name="exp"
               required>

    </div>

    <div class="form-group">

        <label>Invoice Number</label>

        <input type="number"
        		   id="inv"
               name="inv"
               required>

    </div>

    <button type="submit"
            formaction="AddPurchase">

        Add Purchase

    </button>

</div>

</form>
<script>
function Calculate(){
	let qty = document.getElementById('qua').value;
	let uprice = document.getElementById('upri').value;	
	let total = qty * uprice;
	document.getElementById('total').value= total;
}
</script>

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