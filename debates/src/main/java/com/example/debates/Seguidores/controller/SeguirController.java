package com.example.debates.Seguidores.controller;

import com.example.debates.Seguidores.Dto.SeguidoresDto;
import com.example.debates.Seguidores.model.Seguir;
import com.example.debates.Seguidores.service.SeguirService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class SeguirController {


    private final SeguirService seguirService;

    @PostMapping("usuario/seguir/{id}")
    public ResponseEntity<SeguidoresDto> seguirAUnUsuario(@PathVariable UUID id){
        SeguidoresDto seguir = seguirService.seguirUsuario(id);
        return ResponseEntity.status(201).body(seguir);
    }

    @PostMapping("usuario/dejar/seguir/{id}")
    public ResponseEntity<SeguidoresDto> dejarDeSeguir(@PathVariable UUID id){
        SeguidoresDto seguir = seguirService.dejarDeSeguirUsuario(id);
        return ResponseEntity.status(201).body(seguir);
    }
}
