package com.example.debates.Repost.model;

import com.example.debates.Chat.model.Chat;
import com.example.debates.Comentarios.model.Comentario;
import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Guardados.model.Guardado;
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
public class Repost {


        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        private UUID id;

        @ManyToOne
        @JoinColumn(name = "usuario_id")
        private Usuario usuario;

        @ManyToOne
        @JoinColumn(name = "mensaje_id")
        private Chat mensaje;

        private LocalDateTime fechaHora;
        private String tiempoPublicado;


        @OneToMany(mappedBy = "repost")
        @JsonManagedReference
        protected List<Favorito> favoritoList;

        @OneToMany(mappedBy = "repost")
        @JsonManagedReference
        protected List<Guardado> guardados;

        @OneToMany(mappedBy = "repost")
        @JsonManagedReference
        protected List<Comentario> comentarios;


    }
