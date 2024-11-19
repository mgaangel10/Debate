package com.example.debates.Favoritos.model;

import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.UUID;

@Embeddable
@AllArgsConstructor
@NoArgsConstructor
@Data
public class FavoritoId implements Serializable {

    private UUID usuarioId;
    private UUID repostId;
}
