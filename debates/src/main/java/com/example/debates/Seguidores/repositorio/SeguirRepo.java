package com.example.debates.Seguidores.repositorio;

import com.example.debates.Seguidores.model.Seguir;
import com.example.debates.users.model.Usuario;
import org.hibernate.type.descriptor.converter.spi.JpaAttributeConverter;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SeguirRepo extends JpaRepository<Seguir, UUID> {

        Optional<Seguir> findBySeguidorAndSeguido(Usuario seguidor, Usuario seguido);

        int countBySeguidorId (UUID id);
        int countBySeguidoId (UUID id);

        List<Seguir> findBySeguido(Usuario seguido);

        boolean existsBySeguidorAndSeguido(Usuario seguidor, Usuario seguido);


}
