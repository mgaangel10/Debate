package com.example.debates.Notificaciones.model;

import com.example.debates.Debates.model.Debate;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Seguidores.model.Seguir;
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
public class Notificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "repost_id")
    private Repost repost;

    @ManyToOne
    @JoinColumn(name = "seguir_id")
    private Seguir seguir;

    @ManyToOne
    @JoinColumn(name = "debate_id")
    private Debate debate;

    private LocalDateTime fecha;
    private String tiempoNotificacion;

    private String concepto;

}
