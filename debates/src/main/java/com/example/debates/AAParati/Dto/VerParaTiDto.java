package com.example.debates.AAParati.Dto;


import com.example.debates.Debates.Dto.MostrarDebatesDto;
import com.example.debates.Repost.Dto.VerRepostDto;

import java.util.List;
import java.util.stream.Collectors;

public record VerParaTiDto(List<VerRepostDto> verRepostDtos,
                           List<MostrarDebatesDto> mostrarDebatesDtos) {
    public static VerParaTiDto of(List<VerRepostDto> verRepostDtos,List<MostrarDebatesDto> mostrarDebatesDtos){
        return new VerParaTiDto(
                verRepostDtos,
                mostrarDebatesDtos
        );
    }
}
