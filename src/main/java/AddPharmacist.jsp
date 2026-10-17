<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Pharmacist</title>
<style>
body{
	background-color:#F0F0F2;
    font-family:Arial,sans-serif;
}

.all{
	background-color:white;
    width: 550px;               
    margin: 60px auto;
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
.gender {
    display: flex;
    align-items: center;
    gap: 10px;
}

.gender label {
    width: auto;
    font-size: 16px;
    display: flex;
    align-items: center;
    gap: 4px;
}

.gender input {
    margin: 0;
}
</style>
</head>
<body>

<form action="AddPharmacist" method="Post">
<h1>Add Pharmacist</h1>

<div class="all">

<div class="form-group">
<label>Name</label>
<input type="text" name="name" required>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" name="email" required pattern="[a-zA-Z0-9._%+-]+@gmail\.com"
title="Please enter a valid @gmail.com address">
</div>

<div class="form-group">
<label>DOB</label>
<input type="date" name="dob" required>
</div>

<div class="form-group">
<label>Qualification</label>
<input type="text" name="qualification" required>
</div>

<div class="form-group">
<label>Experience</label>
<input type="number" name="exp" required>
</div>

<div class="form-group">
<label>Gender</label>
<input type="radio" value="Male" name="gender"required>Male
<input type="radio" value="Female" name="gender">Female
</div>

<div class="form-group">
<label>Phone</label>
<input type="number" name="phone" required>
</div>

<div class="form-group">
<label>Address</label>
<input type="text" name="address" required>
</div>

<div class="btn">
<button type="submit">Submit</button>
</div>

</div>
</form>
</body>
</html>