<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Register - Railway Booking System</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%
    String message = "";  // Initialize the message variable
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
            if (rowCount > 0) {
                // Registration successful, redirect to login page
                db.closeConnection(con);
                response.sendRedirect("login.jsp?message=Registration successful! Please log in.");
                return;  // Stop further processing of this page
            } else {
                message = "Registration failed.";
            }

            // Close the database connection
            db.closeConnection(con);
        } catch (com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException e) {
            // This exception is thrown if there's a unique constraint violation (e.g., duplicate username or email)
            message = "Username or email already exists. Please try a different one.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<div class="form-container">

    <h2>Create an Account</h2>
    <p class="subtitle">Fill in your details to sign up.</p>

    <!-- Display the error message if there's an issue -->
    <p class="error-message"><%= message %></p>

    <!-- Registration Form -->
    <form method="post" action="register.jsp">
        <input type="text" name="username" placeholder="User ID" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="email" name="email" placeholder="E-Mail Address" required>
        <input type="text" name="first_name" placeholder="First Name">
        <input type="text" name="last_name" placeholder="Last Name">
        <input type="submit" value="Sign Up">
    </form>

    <p class="signup-link">Already have an account? <a href="login.jsp">Sign in</a></p>
</div>

</body>
</html>
