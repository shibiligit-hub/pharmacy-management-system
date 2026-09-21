<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if(session.getAttribute("pharma_name") == null){
    response.sendRedirect("Login.jsp");
    return;
}
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
    		margin-top: 20px;
    		margin-left: 50px;
	}

	button{	
		background-color:white;
    		color: black;
    		width: 250px;
    		height: 61px;
    		font-size: 21px;
    		font-weight: bold;
    		border: none;
	}
	.dropdown{
	    position: relative;
	    display: inline-block;
	}
	.dropdown-content{
	    display: none;
	    position: absolute;
	    background-color: white;
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
    		width:100%;
		margin-top: -180px;    		
		display:flex;
    		justify-content:center;
	}
	.iframe{
		background-color:#F0F0F2;
   		margin-top: 161px;
    		width: 100%;
    		height: 1015px;
    		border: none;
	}
	.btn{
		margin-top: 15px;
	    margin-left: 200px;
	    display: flex;
	    gap: 50px;
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
	
	</style>
	</head>
	<body>
	
	<div class="static-child">
	<div class="show">
	<div class="btn">
	    <div class="dropdown">
	        <button>Purchase Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('AddSupplier.html')">Add Supplier</a>
            <a href="#" onclick="onGo('ViewSupplier.jsp')">View Supplier</a>
            <a href="#" onclick="onGo('AddPurchase.jsp')">Add Purchase</a>
            <a href="#" onclick="onGo('ViewPurchase.jsp')">View Purchase</a>
	        </div>
	    </div>
	
	    <div class="dropdown">
	        <button>Sales Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('AddSales.jsp')">Add Sales</a>
            <a href="#" onclick="onGo('ViewSales.jsp')">View Sales</a>
	        </div>
	    </div>
	
	    <div class="dropdown">
	        <button>Stock Management</button>
	        <div class="dropdown-content">
            <a href="#" onclick="onGo('ViewStock.jsp')">View Stock</a>
	        </div>
	    </div>
	
	    <div class="dropdown">
	        <button >Reports Management</button>
	       	<div class="dropdown-content">
	        <a href="#" onclick="onGo('SearchingPurchase.jsp')">Purchase</a>
	        <a href="#" onclick="onGo('SearchingSales.jsp')">Sales</a>
	   		</div>
	    </div>	
	    <div class="dropdown">
	        <button class="hello" onclick="window.location.href='logout.jsp'">Logout</button>
		</div>	
	</div>
	</div>
	</div>
	<div class="content">
		<iframe
			id="frame"
			name="frame"
			class="iframe">
		</iframe>
	</div>
	<script>
	function onGo(page){
		document.getElementById("frame").src = page;
	}
	</script>
	</body>
	</html>