package com.example.debates.Debates.model;

import com.example.debates.Chat.model.Chat;
import com.example.debates.users.model.Usuario;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Debate {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    private String titulo;
    private String imagen;
    private String descripcion;
    private String categorias;
    @Column(name = "fecha_creacion")
    private LocalDateTime fechaCreacion;
    private String tiempo;


    @OneToOne
    @JoinColumn(name = "ultimo_mensaje_id")
    private Chat chat;

    @ManyToOne
    @JoinColumn(name = "creador_del_debate")
    private Usuario creadorDelDebate;

    @OneToMany(mappedBy = "debate", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Unirse> listaDeUsuariosUnidos;
}
