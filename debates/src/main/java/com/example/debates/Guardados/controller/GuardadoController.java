package com.example.debates.Guardados.controller;

import com.example.debates.Guardados.Dto.GuardarDto;
import com.example.debates.Guardados.service.GuardadoService;
import com.example.debates.Repost.Dto.VerRepostDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class GuardadoController {

    private final GuardadoService guardadoService;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate

    @PostMapping("usuario/guardar/repost/{id}")
    public ResponseEntity<VerRepostDto> GuardarRepost(@PathVariable UUID id){
        VerRepostDto verRepostDto = guardadoService.guardar(id);
        messagingTemplate.convertAndSend("/topic/guardar", verRepostDto);

        return ResponseEntity.status(201).body(verRepostDto);
    }

    @GetMapping("usuario/ver/sus/guardados")
    public ResponseEntity<List<VerRepostDto>> verGuardadosDelUsuario(){
        List<VerRepostDto> verRepostDtos = guardadoService.VerGuardadoUsuario();
        return ResponseEntity.ok(verRepostDtos);
    }

    @DeleteMapping("usuario/quitar/guardado/{id}")
    public ResponseEntity<?> quitarMeGusta(@PathVariable UUID id){
        guardadoService.quitarDeGuardado(id);
        return ResponseEntity.noContent().build();
    }
}
