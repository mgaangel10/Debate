package com.example.debates.Chat.Dto;

import com.example.debates.Chat.model.Chat;

public record EnviarMensajeDto(String contenido) {
    public static EnviarMensajeDto of(Chat c){
        return new EnviarMensajeDto(c.getContenido());
    }
}
