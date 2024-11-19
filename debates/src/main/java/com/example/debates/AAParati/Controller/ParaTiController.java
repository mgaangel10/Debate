package com.example.debates.AAParati.Controller;

import com.example.debates.AAParati.Dto.VerParaTiDto;
import com.example.debates.AAParati.service.ParatiService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ParaTiController {

    private final ParatiService paratiService;

    @GetMapping("usuario/paraTi")
    public ResponseEntity<VerParaTiDto> paraTi(){
        VerParaTiDto verParaTiDto = paratiService.generarContenidoParaTi();
        return ResponseEntity.ok(verParaTiDto);
    }

}
