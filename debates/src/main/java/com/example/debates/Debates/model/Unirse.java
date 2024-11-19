package com.example.debates.Debates.model;

import com.example.debates.users.model.Usuario;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Unirse {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;




    @ManyToOne
    @JoinColumn(name = "usuario_id")
    @JsonIgnore
    private Usuario usuario;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "debate_id")
    private Debate debate;
}
