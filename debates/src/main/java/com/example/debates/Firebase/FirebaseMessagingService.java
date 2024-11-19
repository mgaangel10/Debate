package com.example.debates.Firebase;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import org.springframework.stereotype.Service;

@Service
public class FirebaseMessagingService {

    public void sendMessage(String topic, String messageContent) {
        Message message = Message.builder()
                .putData("message", messageContent)
                .setTopic(topic)
                .build();

        FirebaseMessaging.getInstance().sendAsync(message);
    }
}
