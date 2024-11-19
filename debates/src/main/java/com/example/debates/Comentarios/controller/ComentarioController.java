package com.example.debates.Comentarios.controller;

import com.example.debates.Comentarios.Dto.CrearComentarioDto;
import com.example.debates.Comentarios.Dto.VerComentarioDto;
import com.example.debates.Comentarios.service.ComentarioService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ComentarioController {

    private final ComentarioService comentarioService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate

    @PostMapping("usuario/comentar/repost/{id}")
    public ResponseEntity<VerComentarioDto> crearComentario(@PathVariable UUID id, @RequestBody CrearComentarioDto crearComentarioDto){
        VerComentarioDto verComentarioDto = comentarioService.comentarRepost(id,crearComentarioDto);
        messagingTemplate.convertAndSend("/topic/comentar", verComentarioDto);

        return ResponseEntity.status(201).body(verComentarioDto);
    }

    @GetMapping("usuario/ver/comentarios/repost/{id}")
    public ResponseEntity<List<VerComentarioDto>> verComentariosRepost(@PathVariable UUID id){
        List<VerComentarioDto> verComentarioDtos = comentarioService.obtenerComentariosDeRepost(id);
        return ResponseEntity.ok(verComentarioDtos);
    }

}
