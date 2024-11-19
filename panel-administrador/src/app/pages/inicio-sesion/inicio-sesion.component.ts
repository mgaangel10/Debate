import { Component } from '@angular/core';
import { AdminServiceService } from '../../service/admin-service.service';
import { Router } from '@angular/router';
import { FormControl, FormGroup } from '@angular/forms';
import { LoginResponse } from '../../models/login-administrador';

@Component({
  selector: 'app-inicio-sesion',
  templateUrl: './inicio-sesion.component.html',
  styleUrl: './inicio-sesion.component.css'
})
export class InicioSesionComponent {

  constructor(private loginService:AdminServiceService, private router:Router){}

  profileLogin = new FormGroup({
    email: new FormControl(''),
    password: new FormControl('')
  })

  login() {
    console.log('Datos enviados al servidor:', this.profileLogin.value);

    this.loginService.LoginResponseAdministrador(this.profileLogin.value.email!, this.profileLogin.value.password!)
      .subscribe((l: LoginResponse) => {
        localStorage.setItem('TOKEN', l.token);
        localStorage.setItem('USER_ID', l.id);
        this.router.navigate(['/home']);


      });
  }

}
