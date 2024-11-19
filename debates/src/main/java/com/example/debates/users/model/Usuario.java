package com.example.debates.users.model;


import com.example.debates.Debates.model.Unirse;
import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Guardados.model.Guardado;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Seguidores.model.Seguir;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.springframework.boot.autoconfigure.security.SecurityProperties;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Usuario extends User {
    @ManyToMany
    @JoinTable(name = "tbl_usuario_usuarios",
            joinColumns = @JoinColumn(name = "responsable_id"),
            inverseJoinColumns = @JoinColumn(name = "usuarios_id"))
    private List<Usuario> usuarios = new ArrayList<>();
    @ManyToMany(mappedBy = "usuarios")
    private List<Usuario> inChargeof;

   @OneToMany(mappedBy = "usuario")
    @JsonManagedReference
    private List<Favorito> favoritos ;
    @OneToMany(mappedBy = "seguidor")
    private List<Seguir> seguidos;

    @OneToMany(mappedBy = "seguido")
    private List<Seguir> seguidores;


    @OneToMany(mappedBy = "usuario")
    private List<Unirse> participaciones;

    @OneToMany(mappedBy = "usuario")
    private List<Repost> reposts;

    @OneToMany(mappedBy = "usuario")
    @JsonManagedReference
    private List<Guardado> guardados ;






}
