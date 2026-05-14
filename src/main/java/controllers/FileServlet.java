package controllers;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/assets/images/*")
public class FileServlet extends HttpServlet {
    
    private File getUploadDir() {
        String uploadRoot = getServletContext().getRealPath("/assets/images");
        if (uploadRoot == null) {
            uploadRoot = new File("src/main/webapp/assets/images").getAbsolutePath();
        }
        File uploadDir = new File(uploadRoot);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        return uploadDir;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestedFile = request.getPathInfo();   // e.g., /filename.jpg
        if (requestedFile == null || requestedFile.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Remove leading slash
        if (requestedFile.startsWith("/")) {
            requestedFile = requestedFile.substring(1);
        }

        File file = new File(getUploadDir(), requestedFile);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        response.setContentType(mime != null ? mime : "application/octet-stream");
        response.setContentLengthLong(file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}