import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { InicioSesionComponent } from './pages/inicio-sesion/inicio-sesion.component';
import { HomePageComponent } from './pages/home-page/home-page.component';

const routes: Routes = [

  { path: 'login', component: InicioSesionComponent },
  { path: 'home', component: HomePageComponent },

  { path: '**', redirectTo: '/login', pathMatch: 'full' }


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
