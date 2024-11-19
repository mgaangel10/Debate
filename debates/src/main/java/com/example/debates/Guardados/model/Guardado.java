package com.example.debates.Guardados.model;

import com.example.debates.Favoritos.model.FavoritoId;
import com.example.debates.Repost.model.Repost;
import com.example.debates.users.model.Usuario;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Guardado {

    @EmbeddedId
    private GuardadoId id;

    @ManyToOne
    @MapsId("usuarioId")
    @JsonBackReference
    private Usuario usuario;

    @ManyToOne
    @MapsId("repostId")
    @JsonBackReference
    private Repost repost;
}
