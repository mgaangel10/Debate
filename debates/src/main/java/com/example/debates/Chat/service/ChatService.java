package com.example.debates.Chat.service;

import com.example.debates.Chat.Dto.EnviarMensajeDto;
import com.example.debates.Chat.Dto.VerMensajesChatDto;
import com.example.debates.Chat.model.Chat;
import com.example.debates.Chat.repositorio.ChatRepository;
import com.example.debates.Debates.model.Debate;
import com.example.debates.Debates.repositorio.DebateRepo;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatService {
    private final ChatRepository chatRepository;
    private final DebateRepo debateRepo;
    private final UsuarioRepo usuarioRepo;
    private final TimeFormatterService timeFormatterService;

    public VerMensajesChatDto enviarMensaje(UUID debateId, EnviarMensajeDto enviarMensajeDto) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            Optional<Usuario> optionalUsuario = usuarioRepo.findByEmailIgnoreCase(email);
            Optional<Debate> optionalDebate = debateRepo.findById(debateId);

            if (optionalUsuario.isPresent() && optionalDebate.isPresent() && enviarMensajeDto.contenido()!=null) {
                Usuario usuario = optionalUsuario.get();
                Debate debate = optionalDebate.get();

                Chat chatMensaje = new Chat();
                chatMensaje.setUsuario(usuario);
                chatMensaje.setDebate(debate);
                chatMensaje.setContenido(enviarMensajeDto.contenido());
                LocalDateTime fechaHoraActual = LocalDateTime.now();
                chatMensaje.setFechaHora(fechaHoraActual);
                String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                chatMensaje.setTiempoDeEnvio(tiempoPublicado);
                chatRepository.save(chatMensaje);

                debate.setChat(chatMensaje);
                debateRepo.save(debate);


                return VerMensajesChatDto.of(chatMensaje);
            }
        }
        return null;
    }

    public List<VerMensajesChatDto> verMensajesDelChat(UUID id){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            Optional<Debate> debate = debateRepo.findById(id);
            if (usuario.isPresent()&&debate.isPresent()){

                List<Chat> chats = chatRepository.obtenerIdDebateId(id);
               List<VerMensajesChatDto> verMensajesChatDtos1 = chats.stream().map(chat -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(chat.getFechaHora());
                    chat.setTiempoDeEnvio(tiempoPublicado);
                    return chat;
                }).map(VerMensajesChatDto::of).collect(Collectors.toList());
                return verMensajesChatDtos1;
            }
        }
        return null;
    }
}
