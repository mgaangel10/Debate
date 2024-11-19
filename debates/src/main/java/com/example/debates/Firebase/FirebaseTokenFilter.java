package com.example.debates.Firebase;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;

public class FirebaseTokenFilter extends AbstractPreAuthenticatedProcessingFilter {

    @Override
    protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // Eliminar el prefijo "Bearer "
            try {
                // Verificar el token de Firebase
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(token);
                return new UsernamePasswordAuthenticationToken(decodedToken.getUid(), null, null);
            } catch (FirebaseAuthException e) {
                e.printStackTrace();
            }
        }
        return null;
    }


    @Override
    protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
        return null; // No es necesario retornar credenciales para Firebase
    }
}
