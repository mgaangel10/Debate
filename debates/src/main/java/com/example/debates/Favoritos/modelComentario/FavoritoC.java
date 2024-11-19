package com.example.debates.Favoritos.modelComentario;

import com.example.debates.Comentarios.model.Comentario;
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
public class FavoritoC {

    @EmbeddedId
    private FavoritoCID id;

    @ManyToOne
    @MapsId("usuarioId")
    @JsonBackReference
    private Usuario usuario;

    @ManyToOne
    @MapsId("comentarioId")
    @JsonBackReference
    private Comentario comentario;
}
