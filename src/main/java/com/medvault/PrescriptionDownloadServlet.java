package com.medvault;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

public class PrescriptionDownloadServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String prescriptionIdStr = request.getParameter("id");
        if (prescriptionIdStr == null || prescriptionIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Prescription ID is required");
            return;
        }

        int prescriptionId = Integer.parseInt(prescriptionIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            // Verify access to prescription based on role
            String accessQuery;
            if ("patient".equals(role)) {
                accessQuery = "SELECT p.*, a.appointment_date, d.name as doctor_name, d.specialization, pt.name as patient_name " +
                             "FROM prescriptions p " +
                             "JOIN appointments a ON p.appointment_id = a.id " +
                             "JOIN doctors d ON a.doctor_id = d.id " +
                             "JOIN patients pt ON a.patient_id = pt.id " +
                             "WHERE p.id = ? AND pt.user_id = ?";
            } else if ("doctor".equals(role)) {
                accessQuery = "SELECT p.*, a.appointment_date, d.name as doctor_name, d.specialization, pt.name as patient_name " +
                             "FROM prescriptions p " +
                             "JOIN appointments a ON p.appointment_id = a.id " +
                             "JOIN doctors d ON a.doctor_id = d.id " +
                             "JOIN patients pt ON a.patient_id = pt.id " +
                             "WHERE p.id = ? AND d.user_id = ?";
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            PreparedStatement accessStmt = conn.prepareStatement(accessQuery);
            accessStmt.setInt(1, prescriptionId);
            accessStmt.setInt(2, userId);
            ResultSet accessRs = accessStmt.executeQuery();

            if (!accessRs.next()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied or prescription not found");
                return;
            }

            // Generate PDF
            String patientName = accessRs.getString("patient_name").replaceAll("[^a-zA-Z0-9]", "_");
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Prescription_" + patientName + ".pdf\"");

            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            // Title
            Paragraph title = new Paragraph("Medical Prescription")
                    .setFontSize(24)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setBold()
                    .setMarginBottom(30);
            document.add(title);

            // Header Information Table
            Table headerTable = new Table(UnitValue.createPercentArray(new float[]{1, 1}))
                    .setWidth(UnitValue.createPercentValue(100))
                    .setMarginBottom(30);

            // Left side - Patient Info
            headerTable.addCell(new Cell().add(new Paragraph("Patient Name:").setBold().setFontSize(12)));
            headerTable.addCell(new Cell().add(new Paragraph(accessRs.getString("patient_name")).setFontSize(12)));

            headerTable.addCell(new Cell().add(new Paragraph("Date:").setBold().setFontSize(12)));
            headerTable.addCell(new Cell().add(new Paragraph(java.time.LocalDate.now().toString()).setFontSize(12)));

            // Right side - Doctor Info
            headerTable.addCell(new Cell().add(new Paragraph("Doctor Name:").setBold().setFontSize(12)));
            headerTable.addCell(new Cell().add(new Paragraph(accessRs.getString("doctor_name")).setFontSize(12)));

            headerTable.addCell(new Cell().add(new Paragraph("Specialization:").setBold().setFontSize(12)));
            headerTable.addCell(new Cell().add(new Paragraph(accessRs.getString("specialization")).setFontSize(12)));

            document.add(headerTable);

            // Prescription Details Section
            Paragraph sectionTitle = new Paragraph("Prescription Details")
                    .setFontSize(16)
                    .setBold()
                    .setMarginTop(20)
                    .setMarginBottom(15);
            document.add(sectionTitle);

            // Parse prescription text to extract sections
            String prescriptionText = accessRs.getString("prescription_text");

            // Symptoms Section
            if (prescriptionText.contains("Symptoms:")) {
                Paragraph symptomsTitle = new Paragraph("Symptoms:")
                        .setFontSize(14)
                        .setBold()
                        .setMarginTop(15)
                        .setMarginBottom(5);
                document.add(symptomsTitle);

                String symptoms = extractSection(prescriptionText, "Symptoms:", "Diagnosis:");
                Paragraph symptomsPara = new Paragraph(symptoms.trim())
                        .setFontSize(12)
                        .setMarginBottom(10);
                document.add(symptomsPara);
            }

            // Diagnosis Section
            if (prescriptionText.contains("Diagnosis:")) {
                Paragraph diagnosisTitle = new Paragraph("Diagnosis:")
                        .setFontSize(14)
                        .setBold()
                        .setMarginTop(15)
                        .setMarginBottom(5);
                document.add(diagnosisTitle);

                String diagnosis = extractSection(prescriptionText, "Diagnosis:", "Medicines:");
                Paragraph diagnosisPara = new Paragraph(diagnosis.trim())
                        .setFontSize(12)
                        .setMarginBottom(10);
                document.add(diagnosisPara);
            }

            // Medicines Section
            if (prescriptionText.contains("Medicines:")) {
                Paragraph medicinesTitle = new Paragraph("Medications Prescribed:")
                        .setFontSize(14)
                        .setBold()
                        .setMarginTop(15)
                        .setMarginBottom(5);
                document.add(medicinesTitle);

                String medicines = extractSection(prescriptionText, "Medicines:", "Advice:");
                if (medicines.isEmpty()) {
                    medicines = prescriptionText.substring(prescriptionText.indexOf("Medicines:") + 10).trim();
                }

                Paragraph medicinesPara = new Paragraph(medicines.trim())
                        .setFontSize(12)
                        .setMarginBottom(10);
                document.add(medicinesPara);
            }

            // Advice Section
            if (prescriptionText.contains("Advice:")) {
                Paragraph adviceTitle = new Paragraph("Doctor's Advice:")
                        .setFontSize(14)
                        .setBold()
                        .setMarginTop(15)
                        .setMarginBottom(5);
                document.add(adviceTitle);

                String advice = prescriptionText.substring(prescriptionText.indexOf("Advice:") + 7).trim();
                Paragraph advicePara = new Paragraph(advice.trim())
                        .setFontSize(12)
                        .setMarginBottom(10);
                document.add(advicePara);
            }

            // Footer
            Paragraph footer = new Paragraph("Generated by MedVault Healthcare System")
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginTop(50);
            document.add(footer);

            document.close();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF: " + e.getMessage());
        }
    }

    private String extractSection(String text, String startMarker, String endMarker) {
        int startIndex = text.indexOf(startMarker);
        if (startIndex == -1) return "";

        startIndex += startMarker.length();
        int endIndex = text.indexOf(endMarker, startIndex);
        if (endIndex == -1) return text.substring(startIndex).trim();

        return text.substring(startIndex, endIndex).trim();
    }
}
