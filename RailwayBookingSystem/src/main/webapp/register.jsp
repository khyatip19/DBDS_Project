<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Register</title>
</head>
<body>

<% 
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Prepare and execute the registration query
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");

            String query = "INSERT INTO users (username, password, email, first_name, last_name) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password); // Note: Use password hashing in production!
            pst.setString(3, email);
            pst.setString(4, firstName);
            pst.setString(5, lastName);

            int rowCount = pst.executeUpdate();
            message = (rowCount > 0) ? "Registration successful!" : "Registration failed.";

            // Close the database connection
            db.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<h2>Register</h2>
<form method="post" action="register.jsp">
    <table>
        <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
        <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
        <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
        <tr><td>First Name:</td><td><input type="text" name="first_name"></td></tr>
        <tr><td>Last Name:</td><td><input type="text" name="last_name"></td></tr>
    </table>
    <input type="submit" value="Register">
</form>

<p><%= message %></p>

</body>
</html>
