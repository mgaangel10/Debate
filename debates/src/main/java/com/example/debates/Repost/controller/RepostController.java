package com.example.debates.Repost.controller;

import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Repost.service.RepostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Slf4j
public class RepostController {

    private final RepostService repostService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate
    @MessageMapping("/gifts")
    @SendTo("topic/messages")
    @PostMapping("usuario/repostear/{id}")
    public ResponseEntity<VerRepostDto> repostear(@PathVariable UUID id) {
        VerRepostDto verRepostDto = repostService.repostMensaje(id);
        log.info("repost recibido y procesado");

        // Envía un mensaje a través de WebSocket al canal /topic/messages
        messagingTemplate.convertAndSend("/topic/messages", verRepostDto);

        return ResponseEntity.status(201).body(verRepostDto);
    }

    @GetMapping("usuario/ver/repost/seguidos")
    public ResponseEntity<List<VerRepostDto>> verRepostSeguidos() {
        List<VerRepostDto> verRepostDtos = repostService.verTodosLosRepostDeLosSeguidos();
        return ResponseEntity.ok(verRepostDtos);
    }
}

