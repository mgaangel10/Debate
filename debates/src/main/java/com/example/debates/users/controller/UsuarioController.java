package com.example.debates.users.controller;


import com.example.debates.Debates.repositorio.UnirseRepo;
import com.example.debates.Seguidores.repositorio.SeguirRepo;
import com.example.debates.security.jwt.JwtProvider;
import com.example.debates.users.Dto.*;
import com.example.debates.users.model.UserRoles;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.repositorio.AdministradorRepo;
import com.example.debates.users.repositorio.UsuarioRepo;
import com.example.debates.users.service.UsuarioService;
import com.google.api.client.auth.oauth2.TokenRequest;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;
    private final UsuarioRepo usuarioRepo;
    private final PasswordEncoder passwordEncoder;
    private final AdministradorRepo administradorRepo;
    private final UnirseRepo unirseRepo;
    private final SeguirRepo seguirRepo;
    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
    private static final int PASSWORD_LENGTH = 10;
    private static final Random RANDOM = new SecureRandom();

    public static String generateRandomPassword() {
        StringBuilder password = new StringBuilder(PASSWORD_LENGTH);
        for (int i = 0; i < PASSWORD_LENGTH; i++) {
            password.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return password.toString();
    }

    @PostMapping("auth/register/user")
    public ResponseEntity<?> crearUser(@RequestBody PostCrearUserDto postCrearUserDto) {
        try {
            Usuario usuario = usuarioService.createWithRole(postCrearUserDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(PostRegistroDto.Usuario(usuario));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @PostMapping("/auth/firebase/login")
    public ResponseEntity<JwtUserResponse> loginWithFirebase(@RequestBody FirebaseUserDto uid) {
        String password = generateRandomPassword();
            if (usuarioRepo.existsByEmailIgnoreCase(uid.getEmail())||administradorRepo.existsByEmailIgnoreCase(uid.getEmail())){
                PostLogin postLogin = new PostLogin(uid.getEmail(), password);

                usuarioService.setearEnabled(postLogin);
                Authentication authentication = authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                postLogin.email(),
                                postLogin.password()
                        )
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);
                String token = jwtProvider.generateToken(authentication);
                Usuario usuario1 = (Usuario) authentication.getPrincipal();
                return ResponseEntity.status(HttpStatus.CREATED)
                        .body(JwtUserResponse.ofUsuario(usuario1, token));
            }else {

            }

                Usuario usuario = Usuario.builder()
                        .email(uid.getEmail())
                        .name(uid.getNombre())
                        .lastName(null)
                        .fotoUrl(uid.getFotoPerfil())
                        .password(passwordEncoder.encode(password))
                        .createdAt(LocalDateTime.now())
                        .birthDate(null)
                        .roles(EnumSet.of(UserRoles.USER))
                        .enabled(false)
                        .build();

                usuarioRepo.save(usuario);
            PostLogin postLogin = new PostLogin(uid.getEmail(), password);

        usuarioService.setearEnabled(postLogin);
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        postLogin.email(),
                        postLogin.password()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        Usuario usuario1 = (Usuario) authentication.getPrincipal();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.ofUsuario(usuario1, token));


    }




    @PostMapping("/auth/login/user")
    public ResponseEntity<JwtUserResponse> loginUser(@RequestBody PostLogin postLogin) {
        usuarioService.setearEnabled(postLogin);
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        postLogin.email(),
                        postLogin.password()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        Usuario usuario = (Usuario) authentication.getPrincipal();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.ofUsuario(usuario, token));
    }




    @GetMapping("usuario/ver/detalles/{id}")
    public ResponseEntity<VerPerfilUsuarioDto> verDetallesUsuario(@PathVariable UUID id) {
        VerPerfilUsuarioDto usuario1 = usuarioService.getUsuario(id);
        return ResponseEntity.ok(usuario1);
    }

    @GetMapping("usuario/ver/perfil")
    public ResponseEntity<VerPerfilUsuarioDto> verPerfil() {
        VerPerfilUsuarioDto verPerfilUsuarioDto = usuarioService.verPerfilUsuario();
        return ResponseEntity.ok(verPerfilUsuarioDto);
    }
}
