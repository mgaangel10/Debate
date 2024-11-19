package com.example.debates.Seguidores.model;

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
public class Seguir {


        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        private UUID id;

        @ManyToOne
        @JoinColumn(name = "seguidor_id")
        private Usuario seguidor;

        @ManyToOne
        @JoinColumn(name = "seguido_id")
        private Usuario seguido;
        private String siguiendo;
        private LocalDateTime fecha;
        private String tiempoSeguido;
    }
