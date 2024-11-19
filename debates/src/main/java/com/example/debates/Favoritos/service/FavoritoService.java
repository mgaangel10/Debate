package com.example.debates.Favoritos.service;

import com.example.debates.Comentarios.Dto.VerComentarioDto;
import com.example.debates.Comentarios.model.Comentario;
import com.example.debates.Comentarios.repositorio.ComentarioRepo;
import com.example.debates.Favoritos.Dto.megustaDto;
import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Favoritos.model.FavoritoId;
import com.example.debates.Favoritos.modelComentario.FavoritoC;
import com.example.debates.Favoritos.modelComentario.FavoritoCID;
import com.example.debates.Favoritos.repositori.FavoritoComentarioRepo;
import com.example.debates.Favoritos.repositori.FavoritoRepo;
import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Repost.repositorio.RepostRepo;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoritoService {

    private final FavoritoRepo favoritoRepo;
    private final UsuarioRepo usuarioRepo;
    private final RepostRepo repostRepo;
    private final ComentarioRepo comentarioRepo;
    private final FavoritoComentarioRepo favoritoComentarioRepo;

    public VerRepostDto darMegusta(UUID repost) {

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()) {
                Optional<Repost> repost1 = repostRepo.findById(repost);

                Favorito favorito = Favorito.builder()
                        .id(new FavoritoId(usuario1.get().getId(), repost))
                        .repost(repost1.get())
                        .usuario(usuario1.get())
                        .build();
                favoritoRepo.save(favorito);
                Optional<Favorito> favorito1 = favoritoRepo.findByUsuarioIdAndRepostId(usuario1.get().getId(), repost);
                boolean like;
                if (favorito1.isPresent()){
                    like=true;
                }else{
                    like=false;
                }
                return VerRepostDto.of(repost1.get());
            }
        }
        return null;
    }

    public VerComentarioDto darMegustaComentario(UUID comentario) {

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()) {
                Optional<Comentario> repost1 = comentarioRepo.findById(comentario);

                FavoritoC favorito = FavoritoC.builder()
                        .id(new FavoritoCID(usuario1.get().getId(), comentario))
                        .comentario(repost1.get())
                        .usuario(usuario1.get())
                        .build();
                favoritoComentarioRepo.save(favorito);
                return VerComentarioDto.of(repost1.get());
            }

        }

        return null;


    }

    public List<VerRepostDto> verMegustasUsuario() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                List<Repost> reposts = usuario.get().getFavoritos().stream().map(Favorito::getRepost).collect(Collectors.toList());
                List<VerRepostDto> verRepostDtos = reposts.stream().map(VerRepostDto::of).collect(Collectors.toList());
                return verRepostDtos;
            }

        }

        return null;
    }

    public void quitarMegusta(UUID repost) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                Optional<Favorito> favorito = favoritoRepo.findById(new FavoritoId(usuario.get().getId(), repost));
                favoritoRepo.delete(favorito.get());
            }

        }
    }

    public void quitarMegustaComentario(UUID comentario) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                Optional<FavoritoC> favorito = favoritoComentarioRepo.findById(new FavoritoCID(usuario.get().getId(), comentario));
                favoritoComentarioRepo.delete(favorito.get());
            }

        }
    }

}
