package com.example.debates.Chat.controller;

import com.example.debates.Chat.Dto.EnviarMensajeDto;
import com.example.debates.Chat.Dto.VerMensajesChatDto;
import com.example.debates.Chat.model.Chat;
import com.example.debates.Chat.service.ChatService;
import com.example.debates.Debates.repositorio.DebateRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate



    @PostMapping("usuario/enviar/{id}")
    public ResponseEntity<VerMensajesChatDto> enviarMensaje(@PathVariable UUID id, @RequestBody EnviarMensajeDto enviarMensajeDto){
        VerMensajesChatDto chat = chatService.enviarMensaje(id, enviarMensajeDto);
        messagingTemplate.convertAndSend("/topic/chatear", chat);

        return ResponseEntity.status(201).body(chat);
    }

    @GetMapping("usuario/ver/mensajes/{id}")
    public ResponseEntity<List<VerMensajesChatDto>> verMensajes(@PathVariable UUID id){
        List<VerMensajesChatDto> verMensajesChatDtos = chatService.verMensajesDelChat(id);
        return ResponseEntity.ok(verMensajesChatDtos);
    }


}
