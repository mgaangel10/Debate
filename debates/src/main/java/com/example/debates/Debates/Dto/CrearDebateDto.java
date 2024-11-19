package com.example.debates.Debates.Dto;

import com.example.debates.Debates.model.Debate;
import com.example.debates.users.model.Usuario;

import java.util.UUID;

public record CrearDebateDto(UUID id,
        String titulo,
                             String imagen,
                             String descripcion,
                             String categorias) {
    public static CrearDebateDto of(Debate d){
        return new CrearDebateDto(d.getId(),
                d.getTitulo(),
                d.getImagen(),
                d.getDescripcion(),
                d.getCategorias()
        );
    }
}
