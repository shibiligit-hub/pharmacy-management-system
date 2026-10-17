<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<%
	int currentPage = 1;
	int recordsPage = 5;
	if(request.getParameter("page")!= null){
		currentPage = Integer.parseInt(request.getParameter("page"));
	}
	int Start = (currentPage - 1) * recordsPage;
	
	
	String pharma_id = request.getParameter("pharma_id");

	Connection conn = DBConnection.getConnection();
	PreparedStatement ps;

	if(pharma_id != null && pharma_id != " "){
	ps = conn.prepareStatement("SELECT * FROM PHARMACIST WHERE PHARMA_ID LIKE ?");
	ps.setString(1,"%"+pharma_id+"%");
	}else{
	ps = conn.prepareStatement("SELECT * FROM PHARMACIST LIMIT ?,?");
	ps.setInt(1,Start);
	ps.setInt(2,recordsPage);
	}
	ResultSet rs = ps.executeQuery();
	PreparedStatement countps = conn.prepareStatement("SELECT COUNT(*) FROM PHARMACIST");
	ResultSet rscount = countps.executeQuery();
	int totalRecords = 0;
	if(rscount.next()){
		totalRecords = rscount.getInt(1);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.heading-section{
    display: flex;
    align-items: center;
    margin-left:100px;
}
h1{
    margin-top: 30px;
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
.tentries{	
	display: flex;
    margin-top: 35px;
    margin-left: 120px;
    font-size: 20px;
    font-weight: bold;
}
.photo img{
	width: 80px;
    height: 80px;
    object-fit: contain;
    margin-top: 37px;
}
table{
    width:100%;
    margin:auto;
    background:white;
    border-collapse:collapse;
    table-layout:auto;
    margin-top : 40px;
}

th{
	background-color:blue;
	color:white;
    text-align:left;
    padding:20px 35px;
    font-size:22px;
    font-weight:700;
	border: 1px solid black;    
}

td{
    text-align:center;
    padding:5px 20px;
    font-weight:500;
    font-size:18px;    
	border: 1px solid black;    
}
.hello{
	margin-top: 8px;
	background-color: White;
    width: 80px;
    	height: 40px;
    	font-size: 18px;
    	border: none;
    	border-radius: 5px;
    	cursor: pointer;
    	gap:5px;
}
.back-btn{
	display:block;
    margin:20px auto;
}
.heeee{
	width:500px;
	height:35px;
	font-size:19px;
	margin-top:45px;
	margin-left:600px;
}
td:last-child {
    text-align: center;
    white-space: nowrap;
}
.hai{
	margin-top: 8px;
    background-color: white;
    width: 80px;
    height: 40px;
    font-size: 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
.search{
	margin-left: 7px;
	margin-top:45px;
	border-radius: 5px;
    width: 115px;
    background-color: #315BEA;
    height: 40px;
    color: white;
    font-size:19px;
}
.reset{
	margin-left: 7px;
	border-radius: 5px;
	margin-top:45px;
    width: 115px;
    background-color: #F5A623;
    height: 40px;
    color: white;
    font-size:19px;
}
.navigation{
    width:95%;
    margin:20px auto;
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
}
.prev-btn{
	margin-left: 56px;
}

.next-btn{
    justify-self:end;
    margin-right:30px;
}
.jomon{
    padding:10px 20px;
    font-size:15px;
    cursor:pointer;
}
.nav-buttons{
    background-color:blue;
    color:white;
    width:83px;
    height:35px;
    font-size:14px;
}
.button-style{
	padding:10px 20px;
    font-size:15px;
    border-radius:5px;
    cursor:pointer;
	display:block;
	margin:20px auto;
	font-size: 19px;
	width: 52px;
    height: 40px;
}
.diff input{
    background-color:white;
    border:none;
    font-size:18px;
    font-weight:500;
    width:90px;
    padding:2px;
    box-sizing:border-box;
}
.hello{
	margin-top: 8px;
    	background-color: White;
    	color: white;
    width: 80px;
    	height: 40px;
    	font-size: 18px;
    	border: none;
    	border-radius: 5px;
    	cursor: pointer;
    	gap:5px;
}

</style>
</head>
<body>
<%
int count = 0+Start;
if(rs.next()){ 
count++;
%>
<div class="heading-section">
<div class="photo">
<img src="pharmacistslogo.png">
</div>
<div class="heading-text">
<h1>View Pharmacists</h1>
<p>View and Manage All Pharmacists</p>
</div>		
<form action="ViewPharmacists.jsp" method="get">
<input type="text" placeholder='search by Pharma ID'
 name="pharma_id" id="stk" class="heeee" value="<%= pharma_id != null ? pharma_id : "" %>">
<button class="search" type="submit">Search</button>
<button class="reset" type="reset" onClick="window.location.href='ViewPharmacists.jsp'">Reset</button>
</form>
</div>
<table>
<tr>
    <th>ID</th>
   	<th>Actions</th> 
    <th>Name</th>
    <th>Email</th>
    <th>Pharma ID</th>
    <th>Qualification</th>
    <th>Experience</th>
    <th>Gender</th>
    <th>DOB</th>
    <th>Address</th>
    <th>Phone</th>
</tr>
<%do{ %>
<tr id="row<%= rs.getString("PHARMA_ID") %>">
	<td><%=count++ %></td>
	<td>
	<form action="EditPharmacist" method="post" id="<%=rs.getString("PHARMA_ID")%>">
	<button class="hello" onclick="editting('<%=rs.getString("PHARMA_ID") %>')" type="button"><img src="Edit.jpg" style="width:30px;"><br></button>
	<input type="hidden" value="<%=rs.getString("PHARMA_ID") %>" name="pharma_id">
	<button class="hello"  type="submit"><img src="Save.png" style="width:30px;margin-top:10px;"></button>
	</form>
	</td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("Name") %>" name="name" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("Email") %>" name="email" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("PHARMA_ID") %>" name="pharma_id" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("QUALIFICATION") %>" name="qualification" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("EXPERIENCE") %>" name="experience" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("GENDER") %>" name="gender" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("DOB") %>" name="dob" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("ADDRESS") %>" name="address" disabled></td>
	<td class="diff" id="one"><input type="text" form="<%= rs.getString("PHARMA_ID") %>" value="<%=rs.getString("PHONE") %>" name="phone" disabled></td>
</tr>
<%}while(rs.next()); %>
</table>
<div class="navigation">
<div class="prev-btn">
<%if (currentPage > 1){ %>
<a href="ViewPharmacists.jsp?page=<%= currentPage - 1 %>">
<button type="submit" class="nav-buttons">Previous</button>
</a>
<%} %>
</div>
<button class="jomon"><%=currentPage %></button>
<div class="next-btn">
<%if(totalRecords > currentPage * recordsPage){ %>
<a href="ViewPharmacists.jsp?page=<%= currentPage + 1 %>">
<button type="button" class="nav-buttons">Next</button>
</a>
<%}%>
</div>
</div>
<%
}else{
%>
<h2 style="text-align:center; margin-top:50px;">
    No Pharmacists Data Found
</h2>
<a href="ViewPharmacists.jsp">
<button class="back-btn">

        Back to Purchase
    </button>

</a>
<%
}
%>

<script>
let editingRow = null;
function editting(id){
	if(editingRow != null){
		let Previousrow = document.getElementById("row" + editingRow);
		let PreviousInputs = Previousrow.querySelectorAll("input[type='text']");
		PreviousInputs.forEach(input =>{input.disabled=true;});
	}
	let row = document.getElementById("row" + id);
	let inputs = row.querySelectorAll("input[type='text']");
	inputs.forEach(input =>{input.disabled=false;});
	editingRow = id;
}
</script>
</body>
</html>