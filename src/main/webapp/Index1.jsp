<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@  page import="java.time.LocalDate" %>
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
	Connection conn = null;
	PreparedStatement ps = null;
	LocalDate today = LocalDate.now();
	LocalDate tendayBefore = today.plusDays(10);
	ResultSet rs = null;
	conn = DBConnection.getConnection();
	ps = conn.prepareStatement("SELECT USERNAME,TYPE FROM LOGIN");
	rs = ps.executeQuery();
	String pharmaName = (String) session.getAttribute("pharma_name");
	PreparedStatement ps1 = conn.prepareStatement("SELECT TYPE FROM LOGIN WHERE USERNAME = ?");
	ps1.setString(1,pharmaName);
	ResultSet rs1 = ps1.executeQuery();
	String tippu = " ";
	if(rs1.next()){
		tippu = rs1.getString("TYPE");
	}
	
	PreparedStatement noti = conn.prepareStatement("SELECT COUNT(PRODUCT_NAME) FROM STOCKS WHERE EXPIRY_DATE BETWEEN CURDATE() AND ?");
	noti.setDate(1,java.sql.Date.valueOf(tendayBefore));
	ResultSet rsnoti = noti.executeQuery();
	int countExp = 0; 
	if(rsnoti.next()){
		countExp = rsnoti.getInt(1);
	}
	int alqty = 50;
	PreparedStatement lownoti = conn.prepareStatement("SELECT COUNT(PRODUCT_NAME) FROM STOCKS WHERE PRODUCT_QUANTITY <= ?");
	lownoti.setInt(1,alqty);
	ResultSet lowrs = lownoti.executeQuery();
	int countlowstock = 0;
	if(lowrs.next()){
		countlowstock = lowrs.getInt(1);
	}
	
	PreparedStatement expirespre = conn.prepareStatement("SELECT COUNT(PRODUCT_NAME) FROM STOCKS WHERE EXPIRY_DATE < CURDATE()");
	ResultSet resexpiry = expirespre.executeQuery();
	int countexpiredstock = 0;
	if(resexpiry.next()){
		countexpiredstock = resexpiry.getInt(1);
	}
	
	int NotificationCount = countlowstock + countExp + countexpiredstock;
%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>Home Page</title>
	<style>
	h1{
		text-align:center;
	}
	.static-child{
    		width: 100%;
    		height: 102px;
    		margin-top: -4px;
    		margin-left: -90px;
	}
	button{
    		width: 194px;
    		background-color:white;
    		border:none;
    		color:black;
    		height: 30px;
    		font-size: 18px;
    		padding: 0 3px;
	}
	.dropdown{
	    position: relative;
	    display: inline-flex;
	    align-items:center;
	}
	.dropdown-content{
	    display: none;
	    position: absolute;
	    background-color: white;
	    top:80%;
	    min-width: 180px;
	    box-shadow: 0px 4px 8px rgba(0,0,0,0.2);
	    z-index: 1;
	}
	.dropdown-content a{
	    display: block;
	    padding: 12px;
	    text-decoration: none;
	    color: black;
	}
	
	.dropdown-content a:hover{
	    background-color: #f1f1f1;
	}
	.dropdown:hover .dropdown-content{
	    display: block;
	}
	.content{
		width: 100%;
    		margin-top: -196px;
    		display: flex;
    		justify-content: center;
	}
	.iframe{
		background-color:#F0F0F2;
   		margin-top: 161px;
    		width: 100%;
    		height: 1015px;
    		border: none;
	}
	.btn{
		margin-top: -90px;
    		margin-left: 435px;
    		display: flex;
    		flex-direction: row;
    		width:auto;
    		gap: 15px;
	}
	.hello{
		margin-top: 8px;
    		background-color: #0066ff;
    		color: white;
        	width: 100px;
    		height: 40px;
    		font-size: 14px;
    	    border: none;
    		border-radius: 5px;
    		cursor: pointer;
	}
	.photo{
		width: 36px;
    		height: 36px;
    		object-fit:contain;
    	}
    .logophoto{
		width: 80px;
    		height: 80px;
    		object-fit:contain;
    		margin-left:-70px;
    	}
    	.profile{
    	    margin-left:0;
    		width: 45px;
    		height: 45px;
    		border-radius: 50%;
    		object-fit: cover;
    	}
    	.uname{
    		color:black;
    		font-weight:BOLD;
    		margin-right:15px;
    		font-size:21px;
    	}
	.kayapp {
    		display: flex;
    		align-items: center;
    		margin-left: -46px;
    		margin-top: -36px;
    	}
	.bellicon{
		width: 40px;
    		height: 40px;
		margin-left:8px;
	}
	.photos{
		width:400px;
	}
	span{
    		margin-top: -23px;
    		background-color: red;
    		color:white;
    		width: 18px;
    		height: 17px;
    		margin-left: -16px;
    		text-align: center;
    		border-radius:60%;
	}
	</style>
	</head>
	<body>
		<div class="kayapp">
		<img src="title.jpeg" class="photos">
	</div>
	<div class="static-child">	
		<div class="btn">
		
	    <div class="dropdown">
	       <img src="sales.png" class="photo">
	        <button>Users Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('AddPharmacist.jsp')">Add Pharmacists</a>
            <a href="#" onclick="onGo('ViewPharmacists.jsp')">View Pharmacists</a>
	        </div>
	    </div>		
		
	    <div class="dropdown">
	    		<img src="purchase.png" class="photo">
	        <button>Purchase Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('AddSupplier.html')">Add Supplier</a>
            <a href="#" onclick="onGo('ViewSupplier.jsp')">View Supplier</a>
            <a href="#" onclick="onGo('AddPurchase.jsp')">Add Purchase</a>
            <a href="#" onclick="onGo('ViewPurchase.jsp')">View Purchase</a>
            	<% if("ADMIN".equals(tippu)){ %>
            <a href="#" onclick="onGo('AddPharmacist.jsp')">Add Pharmcists</a>
            <a href="#" onclick="onGo('ViewPharmacists.jsp')">View Pharmcists</a>  
            <%} %>        
	        </div>
	    </div>
	
	    <div class="dropdown">
	       <img src="sales.png" class="photo">
	        <button>Sales Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('AddSales.jsp')">Add Sales</a>
            <a href="#" onclick="onGo('ViewSales.jsp')">View Sales</a>
	        </div>
	    </div>
	
	    <div class="dropdown">
	    	    <img src="stock.png" class="photo">
	        <button>Stock Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('ViewStock.jsp')">View Stock</a>
	        </div>
	    </div>
	
	    <div class="dropdown">
	    	    <img src="reports.png" class="photo">
	        <button >Reports Management</button>
	       	<div class="dropdown-content">
	        <a href="#" onclick="onGo('SearchingPurchase.jsp')">Purchase</a>
	        <a href="#" onclick="onGo('SearchingSales.jsp')">Sales</a>
	   		</div>
	   	</div>
	   	<div class="dropdown">
	   		<img src="bellicon.avif" class="bellicon" onclick="onGo('Notifications.jsp')">
	   		<span><%=NotificationCount %></span>
	    </div>	
	    <div class="dropdown">
	    		<img src="p.png" class="profile">
	    		<p class="uname"><%=pharmaName%></p>
	        <button class="hello" onclick="window.location.href='logout.jsp'">Logout</button>
		</div>	
	</div>
	</div>
	<div class="content">
		<iframe
    			id="frame"
    			name="frame"
    			class="iframe"
    			src="DashBoard.jsp">
		</iframe>
	</div>
	<script>
	function onGo(page){
		document.getElementById("frame").src = page;
	}
	</script>
	</body>
	</html>
