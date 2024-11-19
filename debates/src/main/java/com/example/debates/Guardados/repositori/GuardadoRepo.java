package com.example.debates.Guardados.repositori;

import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Guardados.model.Guardado;
import com.example.debates.Guardados.model.GuardadoId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface GuardadoRepo extends JpaRepository<Guardado, GuardadoId> {
    Optional<Guardado> findByUsuarioIdAndRepostId(UUID usuarioId, UUID repostId);

}
