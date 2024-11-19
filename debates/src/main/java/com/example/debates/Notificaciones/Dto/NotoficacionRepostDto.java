package com.example.debates.Notificaciones.Dto;

import com.example.debates.Notificaciones.model.Notificacion;
import com.example.debates.Repost.Dto.VerRepostDto;

public record NotoficacionRepostDto(String nombreUsuario,
                                    String foto,
                                    String concepto,
                                    String tiempo,
                                    VerRepostDto verRepostDto
                                    ) {
    public static NotoficacionRepostDto of(Notificacion n){
        return new NotoficacionRepostDto(
                n.getRepost().getUsuario().getUsername(),
                n.getRepost().getUsuario().getFotoUrl(),
                n.getConcepto(),
                n.getRepost().getTiempoPublicado(),
                VerRepostDto.of(n.getRepost())


        );
    }
}
