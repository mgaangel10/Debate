package com.example.debates.Debates.service;

import com.example.debates.Chat.service.TimeFormatterService;
import com.example.debates.Debates.Dto.*;
import com.example.debates.Debates.model.Debate;
import com.example.debates.Debates.model.Unirse;
import com.example.debates.Debates.repositorio.DebateRepo;
import com.example.debates.Debates.repositorio.UnirseRepo;
import com.example.debates.Seguidores.model.Seguir;
import com.example.debates.Seguidores.repositorio.SeguirRepo;
import com.example.debates.users.Dto.GetUsuario;
import com.example.debates.users.Dto.VerPerfilUsuarioDto;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;



@Service
@RequiredArgsConstructor
public class DebateServicio {

    private final DebateRepo debateRepo;
    private final UsuarioRepo usuarioRepo;
    private final UnirseRepo unirseRepo;
    private final SeguirRepo seguirRepo;
    private final TimeFormatterService timeFormatterService;

    public CrearDebateDto crearDebate(CrearDebateDto crearDebateDto){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()){
                Debate debate = new Debate();
                debate.setTitulo(crearDebateDto.titulo());
                debate.setImagen(crearDebateDto.imagen());
                debate.setDescripcion(crearDebateDto.descripcion());
                debate.setCreadorDelDebate(usuario.get());
                debate.setCategorias(crearDebateDto.categorias());

                debate.setFechaCreacion(LocalDateTime.now());
                LocalDateTime fechaHoraActual = LocalDateTime.now();
                String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                debate.setTiempo(tiempoPublicado);

                debateRepo.save(debate);
                Unirse unirse = new Unirse();
                unirse.setUsuario(usuario.get());
                unirse.setDebate(debate);
                unirseRepo.save(unirse);
                usuario.get().getParticipaciones().add(unirse);
                usuarioRepo.save(usuario.get());

                return CrearDebateDto.of(debate);
            }
        }
        return null;
    }

    public Unirse unirseAlDebate(UUID idDebate){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            Optional<Debate> debate = debateRepo.findById(idDebate);
            Optional<Unirse> unirse = unirseRepo.findByUsuarioAndDebate(usuario.get(),debate.get());
            if (unirse.isEmpty()){
                Unirse unirse1 = new Unirse();
                unirse1.setUsuario(usuario.get());
                unirse1.setDebate(debate.get());
                return unirseRepo.save(unirse1);
            }else {
                return unirse.get();
            }
        }
        return null;
    }

    public void salirDelDebate(UUID idDebate){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            Optional<Debate> debate = debateRepo.findById(idDebate);
            Optional<Unirse> unirse = unirseRepo.findByUsuarioAndDebate(usuario.get(),debate.get());
            System.out.println("llego aqui");
            if (unirse.isPresent()){
                System.out.println("se hace esto");
                 unirseRepo.delete(unirse.get());
            }else {

            }
        }

    }

    public List<Buscardto> buscarDebatesOUsuarios(BuscarDtoResponse palabra){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()){
                List<Debate> debates = debateRepo.findAll();
                List<MostrarDebatesDto> mostrarDebatesDtos = debates.stream().filter(debate -> debate.getTitulo().toLowerCase().contains(palabra.palabra()) || debate.getDescripcion().toLowerCase().contains(palabra.palabra())).map(debate -> {
                    LocalDateTime fechaHoraActual = LocalDateTime.now();
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                    debate.setTiempo(tiempoPublicado);
                    debateRepo.save(debate);
                    return debate;
                }).map(MostrarDebatesDto::of).collect(Collectors.toList());

                List<Usuario> usuarios = usuarioRepo.findAll();
                List<VerPerfilUsuarioDto> getUsuarios = usuarios.stream()
                        .filter(usuario1 -> usuario1.getName().toLowerCase().contains(palabra.palabra()) || usuario1.getEmail().toLowerCase().contains(palabra.palabra()))
                        .map(usuario1 -> {Optional<Seguir> seguir = seguirRepo.findBySeguidorAndSeguido(usuario.get(),usuario1);
                            boolean siguiendo;
                            if (seguir.isPresent()){
                                siguiendo=true;
                            }else {
                                siguiendo=false;
                            }
                            return VerPerfilUsuarioDto.of(usuario1, siguiendo);
                        }).collect(Collectors.toList());


                Buscardto buscardto = new Buscardto(mostrarDebatesDtos,getUsuarios);
                List<Buscardto> buscardtos = new ArrayList<>();
                buscardtos.add(buscardto);
                return buscardtos;
            }
        }
        return null;
    }
    public MostrarDetallesDebatesDto buscarPorId(UUID id){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            Optional<Debate> debate = debateRepo.findById(id);
            Optional<Unirse> unirse = unirseRepo.findByUsuarioAndDebate(usuario.get(),debate.get());
            if (usuario.isPresent() && debate.isPresent()){
                boolean unido ;
                if (unirse.isPresent()){
                    unido=true;
                }else {
                    unido=false;
                }
                return MostrarDetallesDebatesDto.of(debate.get(), unido);
            }
        }
        return null;
    }

    public List<MostrarDebatesDto> verLosDebatesQueEstaUnido(){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);

            if (usuario.isPresent() ){
                List<Unirse> unirses = unirseRepo.findByUsuario(usuario.get());
                List<Debate> debates = unirses.stream().map(unirse -> unirse.getDebate()).collect(Collectors.toList());
                List<MostrarDebatesDto> mostrarDebatesDtos = debates.stream().map(MostrarDebatesDto::of).collect(Collectors.toList());
                return mostrarDebatesDtos;
            }
        }
        return null;
    }
}
