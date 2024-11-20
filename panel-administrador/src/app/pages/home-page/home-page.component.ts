import { Component, OnInit } from '@angular/core';
import { AdminServiceService } from '../../service/admin-service.service';
import { DebatesTrending } from '../../models/debates-trending';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.css']
})
export class HomePageComponent implements OnInit {
  debatesTrending: DebatesTrending[] = [];

  constructor(private service: AdminServiceService) {}

  ngOnInit(): void {
    this.mostrarDebatesTrending();
  }

  mostrarDebatesTrending() {
    this.service.debatesTrending().subscribe(r => {
      this.debatesTrending = r;
    });
  }
  
  getRandomColor(): string {
    const letters = 'CDEFAB';
    let color = '#';
    for (let i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * letters.length)];
    }
    const alpha = 0.6; // Transparencia del 60%
    return `${color}${alpha.toString(16).substring(2, 4)}`; // Convertir alpha a hexadecimal
  }
  
  
  
  

  separarCategorias(categorias: string): string[] {
    return categorias.split(',');
  }
}
