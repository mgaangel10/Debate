package com.example.debates.Comentarios.Dto;

import com.example.debates.Comentarios.model.Comentario;

import java.util.UUID;

public record VerComentarioDto(UUID id,
                               String foto,
                               String nombreUsuario,
                               UUID idUsuario,
                               String contenido,
                               int cantidadMegusta) {

    public static VerComentarioDto of(Comentario c){
        return new VerComentarioDto(
                c.getId(),
                c.getUsuario().getFotoUrl(),
                c.getUsuario().getUsername(),
                c.getUsuario().getId(),
                c.getContenido(),
                c.getFavoritoList()==null ? 0 : c.getFavoritoList().size()
        );
    }
}
