package com.example.debates.Debates.Dto;

import com.example.debates.Debates.model.Debate;
import com.example.debates.users.model.Usuario;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

public record MostrarDebatesDto (UUID id,
                                 String titulo,
                                 String imagen,
                                 String descripcion,
                                 int numeroPersonasUnidas,
                                 String ultimoMensaje,
                                 String nombreCreador,
                                 String foto,
                                 UUID idCreador,
                                 LocalDateTime fechaCreacion,
                                 String categorias
                                 ){

    public static MostrarDebatesDto of (Debate d){
        return new MostrarDebatesDto(d.getId(),
                d.getTitulo(),
                d.getImagen(),
                d.getDescripcion(),
                d.getListaDeUsuariosUnidos().size(),
                d.getChat() ==null? "No hay mensajes": d.getChat().getContenido(),
                d.getCreadorDelDebate().getUsername(),
                d.getCreadorDelDebate().getFotoUrl(),
                d.getCreadorDelDebate().getId(),
                d.getFechaCreacion(),
                d.getCategorias()
        );
    }

}
