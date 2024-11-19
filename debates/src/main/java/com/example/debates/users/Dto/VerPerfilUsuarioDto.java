package com.example.debates.users.Dto;

import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Seguidores.Dto.SeguidoresDto;
import com.example.debates.users.model.Usuario;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public record VerPerfilUsuarioDto(UUID id,
                                  String name,
                                  String lastName,
                                  String foto,
                                  String nombreUsuario,
                                  int seguidores,
                                  int seguidos,
                                  int debatesUnidos,
                                  int repost,
                                  boolean siguiendo,
                                  List<VerRepostDto> verRepostDtos
                                  ) {
    public static VerPerfilUsuarioDto of(Usuario u,boolean s) {
        System.out.println("ID: " + u.getId());
        System.out.println("Nombre: " + u.getName());
        System.out.println("Seguidores: " + u.getSeguidores().size());
        System.out.println("Seguidos: " + u.getSeguidos().size());
        System.out.println("Participaciones: " + u.getParticipaciones().size());

        return new VerPerfilUsuarioDto(
                u.getId(),
                u.getName(),
                u.getLastName(),
                u.getFotoUrl(),
                u.getUsername(),
                u.getSeguidores().size(),
                u.getSeguidos().size(),
                u.getParticipaciones().size(),
                u.getReposts().size(),
                s,
                u.getReposts().stream().map(VerRepostDto::of).collect(Collectors.toList())

        );
    }

}
