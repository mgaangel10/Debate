package com.example.debates.Notificaciones.Dto;

import com.example.debates.Debates.Dto.MostrarDebatesDto;
import com.example.debates.Notificaciones.model.Notificacion;

public record NotificacionDebateDto(String nombreUsuario,
                                    String foto,
                                    String concepto,
                                    String tiempo,
                                    MostrarDebatesDto mostrarDebatesDto) {

    public static NotificacionDebateDto of(Notificacion n){
        return new NotificacionDebateDto(
                n.getDebate().getCreadorDelDebate().getUsername(),
                n.getDebate().getCreadorDelDebate().getFotoUrl(),
                n.getConcepto(),
                n.getDebate().getTiempo(),
                MostrarDebatesDto.of(n.getDebate())
        );
    }
}
