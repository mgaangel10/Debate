package com.example.debates.Comentarios.model;

import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Favoritos.modelComentario.FavoritoC;
import com.example.debates.Repost.model.Repost;
import com.example.debates.users.model.Usuario;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Comentario {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "repost_id")
    private Repost repost;

    private String contenido;
    private LocalDateTime fecha;

    @OneToMany(mappedBy = "comentario")
    @JsonManagedReference
    protected List<FavoritoC> favoritoList;
}
