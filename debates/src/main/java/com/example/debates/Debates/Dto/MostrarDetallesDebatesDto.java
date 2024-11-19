package com.example.debates.Debates.Dto;

import com.example.debates.Debates.model.Debate;

import java.time.LocalDateTime;
import java.util.UUID;

public record MostrarDetallesDebatesDto(UUID id,
                                        String titulo,
                                        String imagen,
                                        String descripcion,
                                        int numeroPersonasUnidas,
                                        String ultimoMensaje,
                                        String nombreCreador,
                                        String foto,
                                        UUID idCreador,
                                        LocalDateTime fechaCreacion,
                                        boolean unido
){

    public static MostrarDetallesDebatesDto of (Debate d, boolean unido){
        return new MostrarDetallesDebatesDto(d.getId(),
                d.getTitulo(),
                d.getImagen(),
                d.getDescripcion(),
                d.getListaDeUsuariosUnidos().size(),
                d.getChat() ==null? "No hay mensajes": d.getChat().getContenido(),
                d.getCreadorDelDebate().getUsername(),
                d.getCreadorDelDebate().getFotoUrl(),
                d.getCreadorDelDebate().getId(),
                d.getFechaCreacion(),
                unido
        );
    }

}


