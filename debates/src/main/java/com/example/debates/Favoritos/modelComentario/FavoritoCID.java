package com.example.debates.Favoritos.modelComentario;

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
public class FavoritoCID implements Serializable {

    private UUID usuarioId;
    private UUID comentarioId;
}
