package com.example.debates.Debates.controller;

import com.example.debates.Debates.Dto.*;
import com.example.debates.Debates.model.Unirse;
import com.example.debates.Debates.service.DebateServicio;
import jakarta.annotation.security.PermitAll;
import lombok.Generated;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class DebateController {

    private final DebateServicio debateServicio;
    private final SimpMessagingTemplate messagingTemplate; // Inyección de SimpMessagingTemplate

    @PostMapping("usuario/crear/debate")
    public ResponseEntity<CrearDebateDto> crearDebate(@RequestBody CrearDebateDto crearDebateDto){
        CrearDebateDto crearDebateDto1 = debateServicio.crearDebate(crearDebateDto);
        messagingTemplate.convertAndSend("/topic/debate", crearDebateDto);

        return ResponseEntity.status(201).body(crearDebateDto1);
    }

    @PostMapping("usuario/unirse/al/debate/{id}")
    public ResponseEntity<Unirse> unirseAlDebate(@PathVariable UUID id){
        Unirse unirse = debateServicio.unirseAlDebate(id);
        messagingTemplate.convertAndSend("/topic/unirse", unirse);

        return ResponseEntity.status(201).body(unirse);
    }

    @DeleteMapping("usuario/salir/del/debate/{id}")
    public ResponseEntity<?> salirDelDebate(@PathVariable UUID id){
        debateServicio.salirDelDebate(id);


        return ResponseEntity.noContent().build();
    }

    @PostMapping("usuario/buscar")
    public ResponseEntity<List<Buscardto>> buscar(@RequestBody BuscarDtoResponse palabra){
        List<Buscardto> buscardto1 = debateServicio.buscarDebatesOUsuarios(palabra);
      return   ResponseEntity.ok(buscardto1);
    }
    @GetMapping("usuario/buscar/{id}")
    public ResponseEntity<MostrarDetallesDebatesDto> buscarPorId(@PathVariable UUID id){
        MostrarDetallesDebatesDto mostrarDebatesDto = debateServicio.buscarPorId(id);
        return ResponseEntity.ok(mostrarDebatesDto);
    }

    @GetMapping("usuario/ver/debates/unidos")
    public ResponseEntity<List<MostrarDebatesDto>> verDebatesUnidos(){
        List<MostrarDebatesDto> mostrarDebatesDtos = debateServicio.verLosDebatesQueEstaUnido();
        return ResponseEntity.ok(mostrarDebatesDtos);
    }
}
