import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { LoginResponse } from '../models/login-administrador';
import { Observable } from 'rxjs/internal/Observable';
import { DebatesTrending } from '../models/debates-trending';
import { UsuariosTrending } from '../models/usuarios-trending';

@Injectable({
  providedIn: 'root'
})
export class AdminServiceService {

  constructor(private http: HttpClient) { }
  url = "http://localhost:9000";

  LoginResponseAdministrador(email: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.url}/auth/login/admin`,
      {
        "email": `${email}`,
        "password": `${password}`
      });
  }

  debatesTrending():Observable<DebatesTrending[]>{
    let token = localStorage.getItem('TOKEN');
    return this.http.get<DebatesTrending[]>(`${this.url}/administrador/debates/trending`,{
      headers: {
        accept: 'application/json',
        'Authorization': `Bearer ${token}`
      }
    })
  }

  usuariosConMasSeguidores():Observable<UsuariosTrending[]>{
    let token = localStorage.getItem('TOKEN');
    return this.http.get<UsuariosTrending[]>(`${this.url}/administrador/users/trending`,{
      headers: {
        accept: 'application/json',
        'Authorization': `Bearer ${token}`
      }
    })

  }
}
