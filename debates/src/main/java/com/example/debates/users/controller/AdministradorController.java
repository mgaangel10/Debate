package com.example.debates.users.controller;


import com.example.debates.security.jwt.JwtProvider;
import com.example.debates.users.Dto.JwtUserResponse;
import com.example.debates.users.Dto.PostCrearUserDto;
import com.example.debates.users.Dto.PostLogin;
import com.example.debates.users.Dto.PostRegistroDto;
import com.example.debates.users.model.Administrador;
import com.example.debates.users.model.Usuario;
import com.example.debates.users.service.AdministradorService;
import com.example.debates.users.service.UsuarioService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class AdministradorController {

    private final AdministradorService administradorService;
    private final UsuarioService usuarioService;
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;


    @PostMapping("auth/register/admin")
    public ResponseEntity<?> crearAdministrador(@RequestBody PostCrearUserDto postCrearUserDto) {
        try {
            Administrador administrador = administradorService.createWithRole(postCrearUserDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(PostRegistroDto.Administrador(administrador));
        } catch (ResponseStatusException e) {

            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getReason());
        }
    }


    @PostMapping("auth/login/admin")
    public ResponseEntity<JwtUserResponse> loginadmin(@RequestBody PostLogin postLogin){
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        postLogin.email(),
                        postLogin.password()
                )
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        Administrador administrador = (Administrador) authentication.getPrincipal();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.ofAdminsitrador(administrador, token));
    }

    @PostMapping("administrador/quitar/cuenta/usuario/{usuarioId}")
    public ResponseEntity<Usuario> quitarCuentaUsuario(@PathVariable UUID usuarioId){
        Usuario usuario = administradorService.setearEneable(usuarioId);
        return ResponseEntity.status(201).body(usuario);
    }

    @GetMapping("administrador/ver/usuarios")
    public ResponseEntity<List<Usuario>> listarUsuario(){
        List<Usuario> usuarios = administradorService.listadoUsuarios();
        return ResponseEntity.ok(usuarios);
    }


}
