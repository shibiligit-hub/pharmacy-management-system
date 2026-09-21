<%@ page import="java.sql.*" %>
<%@ page import="hospital.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reports</title>
<style>
.search{
    margin-left: 0px;
    width: 100%;
    height: 200px;
    background-color:white;   
}
.tex{
	padding:10px;
	margin-left:15px;
  	font-size:20px;
    font-weight:bold;
    	display: flex;
	gap: 310px; 
}
.symb{
	margin-left:25px;
	display: flex;
	gap: 30px; 
}
button{
	width: 100px;
	background-color: cornflowerblue;
	color:white;
    height: 33px;
}
.hashsi{
	width: 50px;
    height: 50px;
	background-color: white;
	font-size: 19px; 
	color:blue;
}
.subu{
    width: 120px;
    	height: 50px;
    	font-size: 18px;
    	background-color: #0066ff;	    		
}
.second{
	margin-top:30px;
	margin-left:25px;
	display: flex;
	gap: 35px; 	
}
.excel{
	width: 120px;
    	height: 50px;
    	font-size: 18px;
    	background-color: #556b2f;
	margin-left:500px;    		 
}
.sctext{
  	font-size:20px;
    font-weight:500px;
    	display: flex;
}
.result {
    width: 100%;
    margin-top: 20px;
}

#resultFrame {
    width: 100%;
    height: 500px;
    border: none;
}
input[type="date"]{
    width: 300px;
    height: 50px;
    padding: 8px;
    font-size: 16px; 
    box-sizing: border-box;
}
.btn-style{
    width: 106px;
    height: 38px;
    font-size: 16px;
    color: blue;
    background-color: white;
}
</style>
</head>
<body>
<h1>Purchase Report</h1>
<div class="search">
<div class="tex">
<label>From Date:</label>
<label>To Date:</label>
</div>
<div class="symb">
<input type="date" name="fromdaa" id="fromda">
<button class="hashsi" onClick="changeDate(-1)"> < </button>
<input type="date" name="todaa" id="toda">
<button class="hashsi" onClick="changeDate(1)"> > </button>
<button class="subu" onClick="Click()">Search</button>
<button class="excel" onClick="Excel()">Export Excel</button>
</div>
<div class="second">
<label class="sctext">Quick Dates:</label>
<button class="btn-style" onclick="document.getElementById('resultFrame').src='Today.jsp'">Today</button>
<button class="btn-style" onclick="document.getElementById('resultFrame').src='YesterdayPurchase.jsp'">Yesterday</button>
<button class="btn-style" onclick="document.getElementById('resultFrame').src='ThisWeekPurchase.jsp'">This Week</button>
<button class="btn-style" onclick="document.getElementById('resultFrame').src='ThisMonthPurchase.jsp'">This Month</button>
<button class="btn-style" onclick="document.getElementById('resultFrame').src='ThisYearPurchase.jsp'">This Year</button>
</div>
</div>
<div class="result">
    <iframe id="resultFrame" src=""></iframe>
</div>
<script>
 function Click(){
	 var from = document.getElementById('fromda').value;
	 var to = document.getElementById('toda').value;
	 
	 if(from == "" || to == ""){
		 alert("Please Select Both Dates");
		 return;
	 }	
	
	 document.getElementById('resultFrame').src =
		    "PurchaseDateReport.jsp?fromda=" + from + "&toda=" + to
 }
 function changeDate(days) {
	    var date = document.getElementById("fromda");
	    var currentDate = new Date(date.value);

	    currentDate.setDate(currentDate.getDate() + days);

	    date.value = currentDate.toISOString().split("T")[0];
	}
 function Excel(){
	 alert("Excel Sheet Created");
 }
</script> 
</body>
</html>