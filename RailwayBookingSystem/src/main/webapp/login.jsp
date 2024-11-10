<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login</title>
</head>
<body>

<% 
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Prepare and execute the login query
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Set session attribute and redirect
                session.setAttribute("username", username);
                response.sendRedirect("welcome.jsp"); // Redirect to welcome page
            } else {
                message = "Invalid username or password.";
            }

            // Close the database connection
            db.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<h2>Login</h2>
<form method="post" action="login.jsp">
    <table>
        <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
        <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
    </table>
    <input type="submit" value="Login">
</form>

<p><%= message %></p>

</body>
</html>
