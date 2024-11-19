package com.example.debates.Notificaciones.service;

import com.example.debates.Chat.Dto.VerMensajesChatDto;
import com.example.debates.Chat.model.Chat;
import com.example.debates.Chat.service.TimeFormatterService;
import com.example.debates.Debates.model.Debate;
import com.example.debates.Debates.model.Unirse;
import com.example.debates.Debates.repositorio.DebateRepo;
import com.example.debates.Notificaciones.Dto.NotificacionDebateDto;
import com.example.debates.Notificaciones.Dto.NotificacionSeguidorDto;
import com.example.debates.Notificaciones.Dto.NotoficacionRepostDto;
import com.example.debates.Notificaciones.model.Notificacion;
import com.example.debates.Notificaciones.repositorio.NotifcacionRepo;
import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Repost.repositorio.RepostRepo;
import com.example.debates.Seguidores.model.Seguir;
import com.example.debates.Seguidores.repositorio.SeguirRepo;

import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificacionService {

    private final NotifcacionRepo notifcacionRepo;
    private final UsuarioRepo usuarioRepo;
    private final DebateRepo debateRepo;
    private final RepostRepo repostRepo;
    private final SeguirRepo seguirRepo;
    private final TimeFormatterService timeFormatterService;



    public List<NotoficacionRepostDto> obtenerNotificacionesRepost() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                Usuario usuarioActual = usuario.get();
                List<Usuario> seguidos = usuarioRepo.findBySeguidosSeguidor(usuarioActual);

                List<Repost> reposts = seguidos.stream()
                        .flatMap(seg -> seg.getReposts().stream())
                        .sorted((r1, r2) -> r2.getFechaHora().compareTo(r1.getFechaHora())) // Ordenar por fecha, más reciente primero
                        .collect(Collectors.toList());

                List<Notificacion> notificaciones = reposts.stream().map(repost -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(repost.getFechaHora());
                    repost.setTiempoPublicado(tiempoPublicado);
                    Notificacion notificacion = new Notificacion();
                    notificacion.setConcepto("Ha publicado nuevo contenido");
                    LocalDateTime fechaHoraActual = LocalDateTime.now();
                    String tiempoPublicado1 = timeFormatterService.formatTimeDifference(fechaHoraActual);
                    notificacion.setTiempoNotificacion(tiempoPublicado1);
                    notificacion.setRepost(repost);

                    notifcacionRepo.save(notificacion);

                    return notificacion;
                }).collect(Collectors.toList());

                return notificaciones.stream().map(NotoficacionRepostDto::of).collect(Collectors.toList());
            }
        }
        return null;

    }


    public List<NotificacionDebateDto> notficacionDebate() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                Usuario usuarioActual = usuario.get();
                List<Usuario> seguidos = usuarioRepo.findBySeguidosSeguidor(usuarioActual);

                List<Debate> debates = seguidos.stream()
                        .flatMap(seg -> debateRepo.findByCreadorDelDebate(seg).stream())
                        .sorted((d1, d2) -> d2.getFechaCreacion().compareTo(d1.getFechaCreacion()))
                        .collect(Collectors.toList());

                List<Notificacion> notificaciones = debates.stream().map(debate -> {
                    Notificacion notificacion = new Notificacion();
                    notificacion.setDebate(debate);
                    LocalDateTime fechaHoraActual = LocalDateTime.now();
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                    notificacion.setTiempoNotificacion(tiempoPublicado);
                    notificacion.setConcepto("Ha creado un nuevo debate");
                    notifcacionRepo.save(notificacion);
                    return notificacion;


                }).collect(Collectors.toList());
                return notificaciones.stream().map(NotificacionDebateDto::of).collect(Collectors.toList());
            }

        }

        return null;
    }

    public List<NotificacionSeguidorDto> notificacionSeguidor() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()) {
                Usuario usuarioActual = usuario.get();

                List<Seguir> seguidores = seguirRepo.findBySeguido(usuarioActual);


                List<Notificacion> notificaciones = seguidores.stream().map(seguir -> {
                    Notificacion notificacion = new Notificacion();
                    notificacion.setSeguir(seguir);
                    notificacion.setFecha(LocalDateTime.now());
                    LocalDateTime fechaHoraActual = LocalDateTime.now();
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                    notificacion.setTiempoNotificacion(tiempoPublicado);
                    notificacion.setConcepto("Ha comenzado a seguirte");
                    notifcacionRepo.save(notificacion);
                    return notificacion;
                }).collect(Collectors.toList());


                return notificaciones.stream().map(NotificacionSeguidorDto::of).collect(Collectors.toList());
            }
        }
        return null;
    }
    }

