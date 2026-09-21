<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>

<%
Connection conn = null;

PreparedStatement ps = null;
PreparedStatement stockPs = null;
PreparedStatement purchasePs = null;
PreparedStatement productPs = null;

ResultSet rs = null;
ResultSet stockRs = null;
ResultSet purchaseRs = null;
ResultSet productRs = null;

int id = Integer.parseInt(request.getParameter("id"));

String product = request.getParameter("product");

try {

    conn = DBConnection.getConnection();

    /* =========================
       GET SALES RECORD
       ========================= */

    ps = conn.prepareStatement(
        "SELECT * FROM SALES WHERE ID=?"
    );

    ps.setInt(1, id);

    rs = ps.executeQuery();

    if (!rs.next()) {
        throw new Exception("Sales record not found");
    }

    String oldProduct = rs.getString("PRODUCT_NAME");

    /* If product is not selected, use old product */
    if (product == null || product.trim().equals("")) {
        product = oldProduct;
    }


    /* =========================
       GET STOCK QUANTITY
       ========================= */

    stockPs = conn.prepareStatement(
        "SELECT PRODUCT_QUANTITY " +
        "FROM STOCKS " +
        "WHERE PRODUCT_NAME=?"
    );

    stockPs.setString(1, product);

    stockRs = stockPs.executeQuery();

    double availableQty = 0;

    if (stockRs.next()) {
        availableQty = stockRs.getDouble("PRODUCT_QUANTITY");
    }


    /* =========================
       GET PURCHASE DETAILS
       OF SELECTED PRODUCT
       ========================= */

    purchasePs = conn.prepareStatement(
        "SELECT ID, UNIT_COST_PRICE, INVOICE " +
        "FROM PURCHASE " +
        "WHERE PRODUCT_NAME=? " +
        "ORDER BY ID DESC " +
        "LIMIT 1"
    );

    purchasePs.setString(1, product);

    purchaseRs = purchasePs.executeQuery();

    double unitPrice = 0;
    int invoice = 0;
    int purchaseId = 0;

    if (purchaseRs.next()) {

        purchaseId = purchaseRs.getInt("ID");

        unitPrice = purchaseRs.getDouble("UNIT_COST_PRICE");

        invoice = purchaseRs.getInt("INVOICE");
    }


    /* =========================
       GET PRODUCTS
       ========================= */

    productPs = conn.prepareStatement(
        "SELECT PRODUCT_NAME " +
        "FROM STOCKS " +
        "WHERE PRODUCT_QUANTITY > 0"
    );

    productRs = productPs.executeQuery();

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

    let qty =
        parseFloat(document.getElementById("qty").value) || 0;

    let unitPrice =
        parseFloat(document.getElementById("cprice").value) || 0;

    document.getElementById("price").value =
        qty * unitPrice;
}

</script>

</head>


<body>

<h1>Edit Sales</h1>

<div class="all">

<form method="post" action="EditSales">

    <!-- SALES ID -->

    <input
        type="hidden"
        name="id"
        value="<%=id%>">


    <!-- PURCHASE ID OF SELECTED PRODUCT -->

    <input
        type="hidden"
        name="purid"
        value="<%=purchaseId%>">


    <!-- PRODUCT -->

    <div class="form-group">

        <label>Product Name</label>

        <select
            name="product"
            onchange="changeProduct(this.value)">

            <%
            while(productRs.next()){
            %>

                <option
                    value="<%=productRs.getString("PRODUCT_NAME")%>"
                    <%
                    if(productRs.getString("PRODUCT_NAME").equals(product)){
                    %>
                        selected
                    <%
                    }
                    %>
                >
                    <%=productRs.getString("PRODUCT_NAME")%>
                </option>

            <%
            }
            %>

        </select>

    </div>


    <!-- AVAILABLE QUANTITY -->

    <div class="form-group">

        <label>Available Quantity</label>

        <input
            type="text"
            name="availableQty"
            value="<%=availableQty%>"
            readonly>

    </div>


    <!-- QUANTITY -->

    <div class="form-group">

        <label>Quantity</label>

        <input
            type="text"
            id="qty"
            name="qty"
            value="<%=rs.getDouble("QUANTITY")%>"
            oninput="calculateTotal()">

    </div>


    <!-- UNIT PRICE -->

    <div class="form-group">

        <label>Unit Price</label>

        <input
            type="text"
            id="cprice"
            name="cprice"
            value="<%=unitPrice%>"
            readonly>

    </div>


    <!-- TOTAL PRICE -->

    <div class="form-group">

        <label>Total Price</label>

        <input
            type="text"
            id="price"
            name="price"
            value="<%=rs.getDouble("PRICE")%>"
            readonly>

    </div>


    <!-- INVOICE -->

    <div class="form-group">

        <label>Invoice Number</label>

        <input
            type="text"
            name="inv"
            value="<%=invoice%>"
            readonly>

    </div>


    <!-- PATIENT -->

    <div class="form-group">

        <label>Patient Name</label>

        <input
            type="text"
            name="cname"
            value="<%=rs.getString("CUSTOMER_NAME")%>">

    </div>


    <!-- DOCTOR -->

    <div class="form-group">

        <label>Doctor Name</label>

        <input
            type="text"
            name="dname"
            value="<%=rs.getString("DOCTOR")%>">

    </div>


    <!-- BUTTON -->

    <div class="btn">

        <button type="submit">
            Edit
        </button>

    </div>

</form>

</div>


<script>

/* Calculate when page first opens */

calculateTotal();


/*
 * When product is changed,
 * reload this JSP with the new product.
 */

function changeProduct(product){

    window.location.href =
        "EditSales.jsp?id=<%=id%>&product="
        + encodeURIComponent(product);

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
finally{

    try{
        if(rs != null) rs.close();
    }catch(Exception e){}

    try{
        if(stockRs != null) stockRs.close();
    }catch(Exception e){}

    try{
        if(purchaseRs != null) purchaseRs.close();
    }catch(Exception e){}

    try{
        if(productRs != null) productRs.close();
    }catch(Exception e){}

    try{
        if(ps != null) ps.close();
    }catch(Exception e){}

    try{
        if(stockPs != null) stockPs.close();
    }catch(Exception e){}

    try{
        if(purchasePs != null) purchasePs.close();
    }catch(Exception e){}

    try{
        if(productPs != null) productPs.close();
    }catch(Exception e){}

    try{
        if(conn != null) conn.close();
    }catch(Exception e){}

}

%>