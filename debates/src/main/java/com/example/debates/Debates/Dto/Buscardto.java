package com.example.debates.Debates.Dto;

import com.example.debates.Seguidores.Dto.SeguidoresDto;
import com.example.debates.users.Dto.GetUsuario;
import com.example.debates.users.Dto.VerPerfilUsuarioDto;

import java.util.List;

public record Buscardto(List<MostrarDebatesDto> mostrarDebatesDtos,
                        List<VerPerfilUsuarioDto> usuarios) {

    public static Buscardto of(List<MostrarDebatesDto> debates, List<VerPerfilUsuarioDto> users) {
        return new Buscardto(debates, users);
    }
}
