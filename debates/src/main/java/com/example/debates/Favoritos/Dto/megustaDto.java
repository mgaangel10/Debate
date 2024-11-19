package com.example.debates.Favoritos.Dto;

import com.example.debates.Favoritos.model.Favorito;

import java.util.UUID;

public record megustaDto(UUID idRepost,
                         UUID idUsuario,
                         boolean like) {
    public static megustaDto of (Favorito f,boolean like){
        return new megustaDto(f.getRepost().getId(),
                f.getUsuario().getId(),
                like);
    }
}
