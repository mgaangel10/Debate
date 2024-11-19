package com.example.debates.Guardados.model;

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
public class GuardadoId implements Serializable {

    private UUID usuarioId;
    private UUID repostId;
}
