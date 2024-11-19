package com.example.debates.Repost.repositorio;

import com.example.debates.Chat.model.Chat;
import com.example.debates.Repost.model.Repost;
import com.example.debates.users.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface RepostRepo extends JpaRepository<Repost, UUID> {

    List<Repost> findByUsuario(Usuario usuarioId);
    List<Repost> findAllByOrderByFechaHoraDesc();

    List<Repost> findByMensaje(Chat chat);
}
