package com.example.debates.Notificaciones.controller;

import com.example.debates.Notificaciones.Dto.NotificacionDebateDto;
import com.example.debates.Notificaciones.Dto.NotificacionSeguidorDto;
import com.example.debates.Notificaciones.Dto.NotoficacionRepostDto;
import com.example.debates.Notificaciones.service.NotificacionService;
import com.example.debates.users.Dto.JwtUserResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class NotificacionController {

    private final NotificacionService notificacionService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate

    @GetMapping("usuario/notificacion/repost")
    public ResponseEntity<List<NotoficacionRepostDto>> notificacionRepost(){
        List<NotoficacionRepostDto> notoficacionRepostDtos = notificacionService.obtenerNotificacionesRepost();
        messagingTemplate.convertAndSend("/topic/notificacionRepost", notoficacionRepostDtos);



        return ResponseEntity.ok(notoficacionRepostDtos);
    }

    @GetMapping("usuario/notificacion/debate")
    public ResponseEntity<List<NotificacionDebateDto>> notificacionDebate(){
        List<NotificacionDebateDto> notoficacionDebateDtos = notificacionService.notficacionDebate();



        return ResponseEntity.ok(notoficacionDebateDtos);
    }

    @GetMapping("usuario/notificacion/seguidor")
    public ResponseEntity<List<NotificacionSeguidorDto>> notificacionSeguidor(){
        List<NotificacionSeguidorDto> notoficacionSeguidorDtos = notificacionService.notificacionSeguidor();



        return ResponseEntity.ok(notoficacionSeguidorDtos);
    }



}
