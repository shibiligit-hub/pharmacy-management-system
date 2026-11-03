<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%@  page import="java.time.LocalDate" %>
    
<%
	LocalDate today = LocalDate.now();
	LocalDate tendayBefore = today.plusDays(10);
	Connection conn = DBConnection.getConnection();
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
.border{
	border-radius: 32px;
    padding: 15px;
    background-color: white;
    width: 355px;
    height: 360px;
    margin-left: auto;
    margin-right: 95px;
    border: 1px solid #dceeff;
}
h2{
	text-align:left;
	margin:0;
}
.photo{
	margin-top: 14px;
    width: 80px;
    height: 60px;
    object-fit: contain;
}
.alignn{
	display:flex;
	flex-direction:row;
}
.align{
	display:flex;
	flex-direction:column;
}

a{
	color:black;
	margin-top: 20px;
    font-size: 18px;
    font-weight: bold;
}
label{
	margin-top:5px;
}
button{
	border-radius: 11px;
    margin-left: 16px;
    margin-top: 10px;
    width: 323px;
    height: 40px;
    text-align: center;
    color:blue;
    font-size:15px;
    font-weight:bold;
}
</style>
<body>
<div class="border">
<h2>Notifications</h2>
-----------------------------------------------------------------
<div class="alignn">
<img src="medicineexpiringsonn.png" class="photo">
<div class="align">
<a href="DetailedNotification.jsp?type=soon">Medicine Expiring Soon</a>
<label><%=countExp %> medicines will expire within 10 days</label>
</div>
</div>
-----------------------------------------------------------------
<div class="alignn">
<img src="lowstockwarning.png" class="photo">
<div class="align">
<a href="DetailedNotification.jsp?type=low">Low Stock Alert</a>
<label><%=countlowstock %> medicines are below minimum stock</label>
</div>
</div>
<div class="align">
-----------------------------------------------------------------
</div>
<div class="alignn">
<img src="medicinesexpired.png" class="photo">
<div class="align">
<a href="DetailedNotification.jsp?type=expiredmedicine">Expired Medicines</a>
<label><%=countexpiredstock %> medicines have expired</label>
</div>
</div>
<button onclick="window.location.href='DetailedNotification.jsp?type=all'">View All Details</button>
</div>
</body>
</html>