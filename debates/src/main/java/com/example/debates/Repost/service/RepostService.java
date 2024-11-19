package com.example.debates.Repost.service;

import com.example.debates.AAParati.Dto.VerParaTiDto;
import com.example.debates.Chat.model.Chat;
import com.example.debates.Chat.repositorio.ChatRepository;
import com.example.debates.Chat.service.TimeFormatterService;
import com.example.debates.Debates.Dto.MostrarDebatesDto;
import com.example.debates.Debates.model.Debate;
import com.example.debates.Debates.model.Unirse;
import com.example.debates.Debates.repositorio.DebateRepo;
import com.example.debates.Debates.repositorio.UnirseRepo;

import com.example.debates.Repost.Dto.VerRepostDto;
import com.example.debates.Repost.model.Repost;
import com.example.debates.Repost.repositorio.RepostRepo;
import com.example.debates.Seguidores.model.Seguir;

import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.UsuarioRepo;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.WebSocketMessage;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RepostService {

    private final RepostRepo repostRepo;
    private final ChatRepository chatRepository;
    private final UsuarioRepo usuarioRepo;
    private final UnirseRepo unirseRepo;
    private final DebateRepo debateRepo;
    private final TimeFormatterService timeFormatterService;




    public VerRepostDto repostMensaje(UUID mensajeId) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            Optional<Usuario> optionalUsuario = usuarioRepo.findByEmailIgnoreCase(email);
            Optional<Chat> optionalMensaje = chatRepository.findById(mensajeId);


            if (optionalUsuario.isPresent() && optionalMensaje.isPresent()) {
                Usuario usuario = optionalUsuario.get();
                Chat mensaje = optionalMensaje.get();
                int cantida = mensaje.getCantidadDeRepost() + 1;
                mensaje.setCantidadDeRepost(cantida);
                chatRepository.save(mensaje);

                // Crear el repost
                Repost repost = new Repost();
                repost.setUsuario(usuario);
                repost.setMensaje(mensaje);

                LocalDateTime fechaHoraActual = LocalDateTime.now();
                repost.setFechaHora(fechaHoraActual);
                String tiempoPublicado = timeFormatterService.formatTimeDifference(fechaHoraActual);
                repost.setTiempoPublicado(tiempoPublicado);
                repostRepo.save(repost);
                usuario.getReposts().add(repost);
                usuarioRepo.save(usuario);
                VerRepostDto verRepostDto = VerRepostDto.of(repost);

                return verRepostDto;

            }
        }
        return null;
    }



    public List<VerRepostDto> obtenerRepostsDeUsuario(UUID usuarioId) {
        Optional<Usuario> usuario = usuarioRepo.findById(usuarioId);
        List<Repost>reposts= repostRepo.findByUsuario(usuario.get());
        List<VerRepostDto> verRepostDtos = reposts.stream().map(VerRepostDto::of).collect(Collectors.toList());
        return verRepostDtos;
    }

    public List<VerRepostDto> verTodosLosRepostDeLosSeguidos(){

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            String nombre= ((UserDetails)principal).getUsername();
            Optional<Usuario> usuario = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario.isPresent()){
                Usuario usuario2 = usuario.get();
                List<Usuario> seguidos = usuarioRepo.findBySeguidosSeguidor(usuario2);
                List<Repost> reposts = seguidos.stream()
                        .flatMap(seg -> seg.getReposts().stream())
                        .collect(Collectors.toList());

                List<Repost> misRepost = repostRepo.findByUsuario(usuario.get());
                List<Repost> misRepost1= misRepost.stream().map(repost -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(repost.getFechaHora());
                    repost.setTiempoPublicado(tiempoPublicado);
                    return repost;
                }).collect(Collectors.toList());

                List<Repost> reposts1 = reposts.stream().map(repost -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(repost.getFechaHora());
                    repost.setTiempoPublicado(tiempoPublicado);
                    return repost;
                }).collect(Collectors.toList());

                List<Repost> todosRepost = new ArrayList<>();
                todosRepost.addAll(misRepost1);
                todosRepost.addAll(reposts1);
                return todosRepost.stream().map(VerRepostDto::of).collect(Collectors.toList());


            }

        }

        return null;
    }

    public List<VerRepostDto> verRepostParaUsuario(){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()) {
                List<Unirse> unirses = unirseRepo.findByUsuario(usuario1.get());
                List<Debate> debatesUnidos = unirses.stream()
                        .map(Unirse::getDebate)
                        .collect(Collectors.toList());
                Set<String> categoriasUnidas = debatesUnidos.stream()
                        .map(Debate::getCategorias)
                        .flatMap(categorias -> Arrays.stream(categorias.split(","))) // Asumiendo que las categorías están separadas por comas
                        .map(String::trim)
                        .collect(Collectors.toSet());
                List<Repost> todos = repostRepo.findAll();
                List<Repost> reposts = todos.stream()
                        .filter(repost -> categoriasUnidas
                                .stream().anyMatch(categoria -> repost.getMensaje().getDebate().getCategorias().toLowerCase()
                                        .contains(categoria.toLowerCase()))||
                                (repost.getUsuario().getSeguidores().size()<repost.getFavoritoList().size() ||
                                        repost.getUsuario().getSeguidores().size()<repost.getComentarios().size()||
                                        repost.getUsuario().getSeguidores().size()<repost.getGuardados().size())).collect(Collectors.toList());
                List<Usuario> seguidos = usuarioRepo.findBySeguidosSeguidor(usuario1.get());
                List<Repost> reposts11 = seguidos.stream()
                        .flatMap(seg -> seg.getReposts().stream())
                        .collect(Collectors.toList());

                List<Repost> misRepost = repostRepo.findByUsuario(usuario1.get());
                List<Repost> misRepost1= misRepost.stream().map(repost -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(repost.getFechaHora());
                    repost.setTiempoPublicado(tiempoPublicado);
                    return repost;
                }).collect(Collectors.toList());

                List<Repost> reposts1 = reposts11.stream().map(repost -> {
                    String tiempoPublicado = timeFormatterService.formatTimeDifference(repost.getFechaHora());
                    repost.setTiempoPublicado(tiempoPublicado);
                    return repost;
                }).collect(Collectors.toList());
                List<Repost> resultado = new ArrayList<>();
                resultado.addAll(reposts);
                resultado.addAll(reposts1);
                resultado.addAll(misRepost1);
                return resultado.stream().map(VerRepostDto::of).collect(Collectors.toList());


            }

        }

        return null;
    }
    public List<MostrarDebatesDto> mostrarDebatesAlUsuario(){
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()) {
                // Obtener los debates en los que el usuario está unido
                List<Unirse> unirses = unirseRepo.findByUsuario(usuario1.get());
                List<Debate> debatesUnidos = unirses.stream()
                        .map(Unirse::getDebate)
                        .collect(Collectors.toList());
                // Obtener todas las categorías de los debates unidos
                Set<String> categoriasUnidas = debatesUnidos.stream()
                        .map(Debate::getCategorias)
                        .flatMap(categorias -> Arrays.stream(categorias.split(","))) // Asumiendo que las categorías están separadas por comas
                        .map(String::trim)
                        .collect(Collectors.toSet());
                // Obtener todos los debates
                List<Debate> todosDebates = debateRepo.findAll();
                // Calcular la media de personas unidas
                double totalPersonas = todosDebates.stream()
                        .mapToDouble(debate -> debate.getListaDeUsuariosUnidos().size())
                        .sum();
                double numeroDebates = todosDebates.size();
                double media = totalPersonas / numeroDebates;
                System.out.println(media);
                // Filtrar los debates que tengan más personas unidas que la media y que contengan alguna de las categorías
                List<Debate> debatesFiltrados = todosDebates.stream()
                        .filter(debate -> debate.getListaDeUsuariosUnidos().size() >= media
                                || categoriasUnidas.stream().anyMatch(categoria -> debate.getCategorias().toLowerCase().contains(categoria.toLowerCase())))
                        .collect(Collectors.toList());

                return debatesFiltrados.stream().map(MostrarDebatesDto::of).collect(Collectors.toList());
            }

        }

        return null;
    }

    public VerParaTiDto generarContenidoParaTi() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            String nombre = ((UserDetails) principal).getUsername();
            Optional<Usuario> usuario1 = usuarioRepo.findByEmailIgnoreCase(nombre);
            if (usuario1.isPresent()) {
                List<VerRepostDto> contenidoAleatorio = new ArrayList<>();
                List<MostrarDebatesDto> contenidoAleatorio1 = new ArrayList<>();
                List<VerRepostDto> verReposts = verRepostParaUsuario();
                List<MostrarDebatesDto> mostrarDebates = mostrarDebatesAlUsuario();
                int totalReposts = verReposts.size();
                int totalDebates = mostrarDebates.size();
                int indexReposts = 0;
                int indexDebates = 0;

                while (indexReposts < totalReposts || indexDebates < totalDebates) {
                    // Añadir de 1 a 4 reposts de forma aleatoria
                    int numReposts = Math.min(1 + (int) (Math.random() * 4), totalReposts - indexReposts);
                    for (int i = 0; i < numReposts && indexReposts < totalReposts; i++) {
                        contenidoAleatorio.add(verReposts.get(indexReposts++));
                    }
                    // Añadir de 1 a 2 debates de forma aleatoria
                    int numDebates = Math.min(1 + (int) (Math.random() * 2), totalDebates - indexDebates);
                    for (int i = 0; i < numDebates && indexDebates < totalDebates; i++) {
                        contenidoAleatorio1.add(mostrarDebates.get(indexDebates++));
                    }
                }

                // Mezclar el contenido para mayor aleatoriedad
                Collections.shuffle(contenidoAleatorio);
                Collections.shuffle(contenidoAleatorio1);

                // Asegurarse de que ningún elemento quede fuera al hacer shuffle y luego mezclar


                VerParaTiDto verParaTiDto = new VerParaTiDto(contenidoAleatorio,contenidoAleatorio1);
                return verParaTiDto;
            }
        }
        return null;
    }

}
