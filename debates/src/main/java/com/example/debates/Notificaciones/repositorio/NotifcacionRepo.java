package com.example.debates.Notificaciones.repositorio;

import com.example.debates.Notificaciones.model.Notificacion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface NotifcacionRepo extends JpaRepository<Notificacion, UUID> {


}
