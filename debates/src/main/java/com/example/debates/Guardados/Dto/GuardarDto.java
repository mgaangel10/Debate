package com.example.debates.Guardados.Dto;

import com.example.debates.Guardados.model.Guardado;

import java.util.UUID;

public record GuardarDto(UUID idUsuario,
                         UUID idRepost,
                         boolean like) {
    public static GuardarDto of(Guardado g, boolean like){
        return new GuardarDto(g.getUsuario().getId(),
                g.getRepost().getId(),
                like);
    }
}
