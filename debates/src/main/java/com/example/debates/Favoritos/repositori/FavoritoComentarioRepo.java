package com.example.debates.Favoritos.repositori;

import com.example.debates.Favoritos.modelComentario.FavoritoC;
import com.example.debates.Favoritos.modelComentario.FavoritoCID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavoritoComentarioRepo extends JpaRepository<FavoritoC, FavoritoCID> {
}
