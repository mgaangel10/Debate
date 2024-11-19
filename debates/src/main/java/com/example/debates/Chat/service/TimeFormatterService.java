package com.example.debates.Chat.service;

import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;

@Service
public class TimeFormatterService {


    public String formatTimeDifference(LocalDateTime fechaHora) {
        LocalDateTime ahora = LocalDateTime.now();
        Duration duracion = Duration.between(fechaHora, ahora);

        if (duracion.getSeconds() < 60) {
            return "publicado hace " + duracion.getSeconds() + " segundos";
        } else if (duracion.toMinutes() < 60) {
            return "publicado hace " + duracion.toMinutes() + " minutos";
        } else if (duracion.toHours() < 24) {
            return "publicado hace " + duracion.toHours() + " horas";
        } else {
            long dias = duracion.toDays();
            if (dias == 1) {
                return "publicado hace 1 día";
            } else {
                return "publicado hace " + dias + " días";
            }
        }

    }
}
