package com.example.debates.Seguidores.service;

import com.example.debates.Chat.service.TimeFormatterService;
import com.example.debates.Seguidores.Dto.SeguidoresDto;
import com.example.debates.Seguidores.model.Seguir;
import com.example.debates.Seguidores.repositorio.SeguirRepo;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SeguirService {

    private final SeguirRepo seguimientoRepo;
    private final UsuarioRepo usuarioRepo;
    private final TimeFormatterService timeFormatterService;

    public SeguidoresDto seguirUsuario(UUID seguidoId) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            Optional<Usuario> optionalSeguidor = usuarioRepo.findByEmailIgnoreCase(email);
            Optional<Usuario> optionalSeguido = usuarioRepo.findById(seguidoId);

            if (optionalSeguidor.isPresent() && optionalSeguido.isPresent()) {
                Usuario seguidor = optionalSeguidor.get();
                Usuario seguido = optionalSeguido.get();

                Seguir seguimiento = new Seguir();
                seguimiento.setSiguiendo("Sigues a este usuario");
                seguimiento.setSeguidor(seguidor);
                seguimiento.setSeguido(seguido);
                seguimiento.setFecha(LocalDateTime.now());
                LocalDateTime fechaHoraActual = LocalDateTime.now();
                String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                seguimiento.setTiempoSeguido(tiempoPublicado);

                seguimientoRepo.save(seguimiento);
                optionalSeguidor.get().getSeguidos().add(seguimiento);
                usuarioRepo.save(optionalSeguidor.get());


                return SeguidoresDto.of(seguimiento);
            }
        }
        return null;
    }

    public SeguidoresDto dejarDeSeguirUsuario(UUID seguidoId) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            Optional<Usuario> optionalSeguidor = usuarioRepo.findByEmailIgnoreCase(email);
            Optional<Usuario> optionalSeguido = usuarioRepo.findById(seguidoId);

            if (optionalSeguidor.isPresent() && optionalSeguido.isPresent()) {
                Usuario seguidor = optionalSeguidor.get();
                Usuario seguido = optionalSeguido.get();

                Optional<Seguir> seguimiento = seguimientoRepo.findBySeguidorAndSeguido(seguidor, seguido);
                if (seguimiento.isPresent()) {
                    seguimientoRepo.delete(seguimiento.get());
                    optionalSeguidor.get().getSeguidos().add(seguimiento.get());
                    usuarioRepo.save(optionalSeguidor.get());
                    return SeguidoresDto.of(seguimiento.get());
                }
            }
        }
        return null;
    }
    }
