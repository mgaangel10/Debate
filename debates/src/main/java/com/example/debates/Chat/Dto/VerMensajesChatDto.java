package com.example.debates.Chat.Dto;

import com.example.debates.Chat.model.Chat;

import java.time.LocalDateTime;
import java.util.UUID;

public record VerMensajesChatDto(UUID id,
                                 String nombreDelAutorDelMensaje,
                                 String nombreDelDebate,

                                 String contenido,
                                 int personasReposteadas,
                                 String tiempoPublicado) {
    public static VerMensajesChatDto of (Chat c){
        return new VerMensajesChatDto(c.getId(),
                c.getUsuario().getUsername(),
                c.getDebate().getTitulo(),

                c.getContenido(),
                c.getCantidadDeRepost(),
                c.getTiempoDeEnvio());
    }

}
