package com.example.debates.Comentarios.repositorio;

import com.example.debates.Comentarios.model.Comentario;
import com.example.debates.Repost.model.Repost;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ComentarioRepo extends JpaRepository<Comentario, UUID> {
    List<Comentario> findByRepost(Repost repost);
}
