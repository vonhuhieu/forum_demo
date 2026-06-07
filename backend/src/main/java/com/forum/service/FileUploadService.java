package com.forum.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Handles file uploads by sending them to Cloudinary CDN.
 *
 * Why Cloudinary instead of local disk?
 * - Hugging Face Spaces container filesystem is ephemeral:
 *   files written to local disk are lost on every restart/redeploy.
 * - Cloudinary stores files permanently and serves them via CDN.
 * - Returns absolute HTTPS URLs, so frontend displays images correctly
 *   regardless of which domain (Vercel vs HF Spaces) it is served from.
 */
@Service
public class FileUploadService {

    @Autowired
    private Cloudinary cloudinary;

    /**
     * Upload a single file to Cloudinary.
     * @return map with keys: url (absolute HTTPS), name, type
     */
    public Map<String, String> uploadFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // Upload raw bytes to Cloudinary (works for images, videos, etc.)
        Map uploadResult = cloudinary.uploader().upload(
            file.getBytes(),
            ObjectUtils.asMap(
                "folder",       "forum_uploads",   // organise in a subfolder on Cloudinary
                "resource_type","auto"             // auto-detect image / video / raw
            )
        );

        // secure_url is always HTTPS, works everywhere
        String secureUrl = (String) uploadResult.get("secure_url");

        Map<String, String> data = new HashMap<>();
        data.put("url",  secureUrl);
        data.put("name", file.getOriginalFilename());
        data.put("type", file.getContentType());

        return data;
    }

    /**
     * Upload multiple files to Cloudinary.
     */
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
