package com.example.debates.Chat.repositorio;

import com.example.debates.Chat.Dto.VerMensajesChatDto;
import com.example.debates.Chat.model.Chat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface ChatRepository extends JpaRepository<Chat, UUID> {
    @Query("SELECT c FROM Chat c WHERE c.debate.id = ?1")
    List<VerMensajesChatDto> obtenerIdDebate(UUID debateId);

    @Query("SELECT c FROM Chat c WHERE c.debate.id = ?1")
    List<Chat> obtenerIdDebateId(UUID debateId);
}
