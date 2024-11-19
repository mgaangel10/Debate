package com.example.debates.Debates.repositorio;

import com.example.debates.Debates.model.Debate;
import com.example.debates.Debates.model.Unirse;
import com.example.debates.users.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UnirseRepo extends JpaRepository<Unirse, UUID> {

    Optional<Unirse> findByUsuarioAndDebate(Usuario usuario , Debate debate);

    int countByUsuarioId(UUID id);

    List<Unirse> findByUsuario(Usuario usuario);
}
