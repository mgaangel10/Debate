package com.example.debates.Chat.model;

import com.example.debates.Debates.model.Debate;
import com.example.debates.users.model.Usuario;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Chat {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "debate_id")
    private Debate debate;

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;
    private String contenido;
    private LocalDateTime fechaHora;
    private String tiempoDeEnvio;
    private int cantidadDeRepost;
}
