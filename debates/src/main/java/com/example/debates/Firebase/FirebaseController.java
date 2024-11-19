package com.example.debates.Firebase;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController public class FirebaseController {
    @Autowired
    private FirebaseMessagingService firebaseMessagingService;
    @PostMapping("/usuario/send-notification")
    public ResponseEntity<String> sendNotification(@RequestParam String topic, @RequestParam String message) {
        firebaseMessagingService.sendMessage(topic, message);
        return ResponseEntity.ok("Notification sent!"); } }
