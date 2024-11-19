package com.example.debates.Seguidores.Dto;

import com.example.debates.Seguidores.model.Seguir;

public record SeguidoresDto (
        String siguiendo) {



    public static SeguidoresDto of(Seguir s){
        return new SeguidoresDto(s.getSiguiendo());
    }
}
