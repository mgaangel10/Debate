package com.example.debates.Comentarios.service;

import com.example.debates.Comentarios.Dto.CrearComentarioDto;
import com.example.debates.Comentarios.Dto.VerComentarioDto;
import com.example.debates.Comentarios.model.Comentario;
import com.example.debates.Comentarios.repositorio.ComentarioRepo;
import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Repost.repositorio.RepostRepo;
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
public class ComentarioService {

    private final ComentarioRepo comentarioRepo;
    private final RepostRepo repostRepo;
    private final UsuarioRepo usuarioRepo;


    public VerComentarioDto comentarRepost(UUID repostId, CrearComentarioDto contenido) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            Optional<Usuario> optionalUsuario = usuarioRepo.findByEmailIgnoreCase(email);
            Optional<Repost> optionalRepost = repostRepo.findById(repostId);

            if (optionalUsuario.isPresent() && optionalRepost.isPresent()) {
                Usuario usuario = optionalUsuario.get();
                Repost repost = optionalRepost.get();

                Comentario comentario = new Comentario();
                comentario.setUsuario(usuario);
                comentario.setRepost(repost);
                comentario.setContenido(contenido.contenido());
                comentario.setFecha(LocalDateTime.now());

                 comentarioRepo.save(comentario);
                 return VerComentarioDto.of(comentario);
            }
        }
        return null;
    }

    public List<VerComentarioDto> obtenerComentariosDeRepost(UUID repostId) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            Optional<Repost> repost = repostRepo.findById(repostId);
            if (usuario.isPresent()&&repost.isPresent()){
                List<Comentario> comentarios=comentarioRepo.findByRepost(repost.get());
                List<VerComentarioDto> verComentarioDtos =comentarios.stream().map(VerComentarioDto::of).collect(Collectors.toList());
                return verComentarioDtos;
            }
        }
        return null;
    }
    }
