package com.example.debates.Favoritos.repositori;

import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Favoritos.model.FavoritoId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import javax.crypto.spec.OAEPParameterSpec;
import java.util.Optional;
import java.util.UUID;

public interface FavoritoRepo extends JpaRepository<Favorito, FavoritoId> {

    Optional<Favorito> findByUsuarioIdAndRepostId(UUID usuarioId, UUID repostId);

}
