package com.example.debates.users.repositorio;




import com.example.debates.users.Dto.GetUsuario;
import com.example.debates.users.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UsuarioRepo extends JpaRepository<Usuario, UUID> {
    Optional<Usuario> findFirstByEmail(String email);
    Usuario findByEmail(String email);
    boolean existsByEmailIgnoreCase(String email);
    List<Usuario> findByEnabledFalse();
    List<Usuario> findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String name,String email);
    Optional<Usuario> findByEmailIgnoreCase(String nombre);
    List<Usuario> findByEnabledTrue();
    @Query("SELECT s.seguido FROM Seguir s WHERE s.seguidor = ?1")
    List<Usuario> findBySeguidosSeguidor( Usuario usuario);

    @Query("SELECT s.seguidor FROM Seguir s WHERE s.seguidor = ?1")
    List<Usuario> findBySeguidosSeguidores( Usuario usuario);

    Optional<Usuario> findByFirebaseuid(String firebaseUid);  // Buscar por el UID de Firebase


    @Query("""
            select new com.example.debates.users.Dto.GetUsuario(
            u.id,
            u.username,
              u.name,
              u.lastName,
              u.phoneNumber,
              u.fotoUrl
            
            )
            from Usuario u
            where u.id = ?1
            """)
    GetUsuario getUsuario(UUID uuid);


}