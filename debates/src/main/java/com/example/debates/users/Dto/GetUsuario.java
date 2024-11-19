package com.example.debates.users.Dto;



import com.example.debates.users.model.Usuario;

import java.util.UUID;

public record GetUsuario(UUID id,
                         String username,
                         String name,
                         String lastName,
                         String phoneNumber,
                         String fotoUrl) {
    public static GetUsuario of(Usuario u){
        return new GetUsuario(u.getId(),
                u.getUsername(),
                u.getName(),
                u.getLastName(),
                u.getPhoneNumber(),
                u.getFotoUrl());
    }
}
