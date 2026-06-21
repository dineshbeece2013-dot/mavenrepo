<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head><title>Student Management</title></head>
<body style="font-family: Arial, sans-serif; margin: 40px;">
    <h2>Add Student</h2>
    <form action="students" method="post">
        ID: <input type="text" name="id" required/><br/><br/>
        Name: <input type="text" name="name" required/><br/><br/>
        Email: <input type="text" name="email" required/><br/><br/>
        <input type="submit" value="Add Student"/>
    </form>
    <hr/>
    <h2>Student List</h2>
    <table border="1" cellpadding="8" style="border-collapse: collapse;">
        <tr style="background-color: #f2f2f2;"><th>ID</th><th>Name</th><th>Email</th></tr>
        <c:forEach var="student" items="${studentList}">
            <tr>
                <td>${student.id}</td>
                <td>${student.name}</td>
                <td>${student.email}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>