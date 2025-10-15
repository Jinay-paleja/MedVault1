package com.medvault;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Invalidate the session
            session.invalidate();
        }

        // Redirect to home page
        response.sendRedirect("index.jsp");
    }
}
