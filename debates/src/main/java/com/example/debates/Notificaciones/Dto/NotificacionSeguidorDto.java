package com.example.debates.Notificaciones.Dto;

import com.example.debates.Notificaciones.model.Notificacion;

import java.util.UUID;

public record NotificacionSeguidorDto(UUID id,
                                      String nombreUsuario,
                                      String foto,
                                      String concepto,
                                      String tiempo
                                      ) {

    public static NotificacionSeguidorDto of(Notificacion n){
        return new NotificacionSeguidorDto(
                n.getSeguir().getSeguidor().getId(),
                n.getSeguir().getSeguidor().getUsername(),
                n.getSeguir().getSeguidor().getFotoUrl(),
                n.getConcepto(),
                n.getSeguir().getTiempoSeguido()
        );
    }
}
