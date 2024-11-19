package com.example.debates.Favoritos.controller;

import com.example.debates.Comentarios.Dto.VerComentarioDto;
import com.example.debates.Favoritos.Dto.megustaDto;
import com.example.debates.Favoritos.service.FavoritoService;
import com.example.debates.Repost.Dto.VerRepostDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Slf4j
public class FavoritoController {
    private final FavoritoService favoritoService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate

    @PostMapping("usuario/dar/megusta/{id}")
    public ResponseEntity<VerRepostDto> darMegusta(@PathVariable UUID id) {
        VerRepostDto verRepostDto = favoritoService.darMegusta(id);
        messagingTemplate.convertAndSend("/topic/likes", verRepostDto);

        return ResponseEntity.status(201).body(verRepostDto);
    }



    @PostMapping("usuario/dar/megusta/comentario/{id}")
    public ResponseEntity<VerComentarioDto> darMegustaComentario(@PathVariable UUID id){
        VerComentarioDto verRepostDto = favoritoService.darMegustaComentario(id);
        return ResponseEntity.status(201).body(verRepostDto);
    }

    @GetMapping("usuario/ver/sus/megustas")
    public ResponseEntity<List<VerRepostDto>> verMegustasDelUsuario(){
        List<VerRepostDto> verRepostDtos = favoritoService.verMegustasUsuario();
        return ResponseEntity.ok(verRepostDtos);
    }

    @DeleteMapping("usuario/quitar/megusta/{id}")
    public ResponseEntity<?> quitarMeGusta(@PathVariable UUID id){
        favoritoService.quitarMegusta(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("usuario/quitar/megusta/comentario/{id}")
    public ResponseEntity<?> quitarMeGustaComentario(@PathVariable UUID id){
        favoritoService.quitarMegustaComentario(id);
        return ResponseEntity.noContent().build();
    }
}
