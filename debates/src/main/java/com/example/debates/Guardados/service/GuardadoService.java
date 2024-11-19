package com.example.debates.Guardados.service;

import com.example.debates.Favoritos.Dto.megustaDto;
import com.example.debates.Favoritos.model.Favorito;
import com.example.debates.Favoritos.model.FavoritoId;
import com.example.debates.Guardados.Dto.GuardarDto;
import com.example.debates.Guardados.model.Guardado;
import com.example.debates.Guardados.model.GuardadoId;
import com.example.debates.Guardados.repositori.GuardadoRepo;
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
public class GuardadoService {

    private final GuardadoRepo guardadoRepo;
    private final UsuarioRepo usuarioRepo;
    private final RepostRepo repostRepo;

    public VerRepostDto guardar(UUID repost){

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()){
                Optional<Repost> repost1 = repostRepo.findById(repost);

                Guardado favorito = Guardado.builder()
                        .id(new GuardadoId(usuario1.get().getId(),repost))
                        .repost(repost1.get())
                        .usuario(usuario1.get())
                        .build();
                guardadoRepo.save(favorito);
                Optional<Guardado> favorito1 = guardadoRepo.findByUsuarioIdAndRepostId(usuario1.get().getId(), repost);
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

    public List<VerRepostDto> VerGuardadoUsuario(){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()){
                List<Repost> reposts = usuario.get().getGuardados().stream().map(Guardado::getRepost).collect(Collectors.toList());
                List<VerRepostDto> verRepostDtos = reposts.stream().map(VerRepostDto::of).collect(Collectors.toList());
                return verRepostDtos;
            }

        }

        return null;
    }

    public void quitarDeGuardado(UUID repost){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()){
                Optional<Guardado> favorito = guardadoRepo.findById(new GuardadoId(usuario.get().getId(),repost));
                guardadoRepo.delete(favorito.get());
            }

        }



    }

}
