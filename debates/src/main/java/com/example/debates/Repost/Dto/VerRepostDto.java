package com.example.debates.Repost.Dto;

import com.example.debates.Comentarios.Dto.VerComentarioDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.users.Dto.VerPerfilUsuarioDto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public record VerRepostDto (UUID id,
                            String fotoUsuario,
                            String nombreUsuario,
                            String nombreDebate,
                            String imagenDebate,
                            int cantidadPersonasEnElDebate,
                            String mensajeChat,
                            String tiempoPublicado,
                            int cantidadMegusta,
                            int cantidadGuardados,
                            int cantidaComentraios,
                            int cantidadRespost,
                            List<VerComentarioDto> verComentarioDtos,
                            UUID idUsuario,
                            UUID idDebate,
                            UUID idMensaje
                            ) {
    public static VerRepostDto of(Repost r){
        return new VerRepostDto(
                r.getId(),
                r.getUsuario().getFotoUrl(),
                r.getUsuario().getUsername(),
                r.getMensaje().getDebate().getTitulo(),
                r.getMensaje().getDebate().getImagen(),
                r.getMensaje().getDebate().getListaDeUsuariosUnidos().size(),
                r.getMensaje().getContenido(),
                r.getTiempoPublicado(),
                r.getFavoritoList()==null? 0 : r.getFavoritoList().size(),
                r.getGuardados()==null? 0 : r.getGuardados().size(),
                r.getComentarios()==null ? 0 : r.getComentarios().size(),
                r.getMensaje().getCantidadDeRepost(),
                r.getComentarios() == null ? List.of(): r.getComentarios().stream().map(VerComentarioDto::of).collect(Collectors.toList()),
                r.getUsuario().getId(),
                r.getMensaje().getDebate().getId(),
                r.getMensaje().getId()

        );
    }
}
