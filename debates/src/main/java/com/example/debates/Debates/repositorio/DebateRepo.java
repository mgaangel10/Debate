package com.example.debates.Debates.repositorio;

import com.example.debates.Debates.Dto.MostrarDebatesDto;
import com.example.debates.Debates.model.Debate;
import com.example.debates.users.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

public interface DebateRepo extends JpaRepository<Debate, UUID> {

    List<Debate> findByTituloContainingIgnoreCaseOrDescripcionContainingIgnoreCase(String titulo,String descripcion);

    List<Debate> findByCreadorDelDebate(Usuario usuario);




}
