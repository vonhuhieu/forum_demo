package com.forum.service;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import jakarta.annotation.PostConstruct;

@Service
public class FileUploadService {

    @Value("${app.upload.dir}")
    private String uploadDir;

    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(uploadDir));
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize storage", e);
        }
    }

    public Map<String, String> uploadFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return null;
        }

        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        String extension = "";
        int i = originalFilename.lastIndexOf('.');
        if (i > 0) {
            extension = originalFilename.substring(i);
        }

        String fileName = UUID.randomUUID().toString() + extension;
        Path targetLocation = Paths.get(uploadDir).resolve(fileName);
        Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

        String fileUrl = "/uploads/" + fileName;
        Map<String, String> data = new HashMap<>();
        data.put("url", fileUrl);
        data.put("name", originalFilename);
        data.put("type", file.getContentType());

        return data;
    }

    public List<Map<String, String>> uploadMultipleFiles(MultipartFile[] files) throws IOException {
        List<Map<String, String>> uploadedFiles = new ArrayList<>();
        for (MultipartFile file : files) {
            Map<String, String> fileData = uploadFile(file);
            if (fileData != null) {
                uploadedFiles.add(fileData);
            }
        }
        return uploadedFiles;
    }
}
