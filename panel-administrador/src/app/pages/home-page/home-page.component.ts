import { Component, OnInit, AfterViewInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { AdminServiceService } from '../../service/admin-service.service';
import { UsuariosTrending } from '../../models/usuarios-trending';
import { DebatesTrending } from '../../models/debates-trending';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.css']
})
export class HomePageComponent implements OnInit, AfterViewInit {
  debatesTrending: DebatesTrending[] = [];
  usuariosTrending: UsuariosTrending[] = [];
  dataSource: MatTableDataSource<UsuariosTrending>;

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  displayedColumns: string[] = ['position', 'Nombre', 'usuario', 'seguidores'];

  constructor(private service: AdminServiceService) {
    this.dataSource = new MatTableDataSource(this.usuariosTrending);
  }

  ngOnInit(): void {
    this.mostrarDebatesTrending();
    this.mostrarUsuariosTrending();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  mostrarDebatesTrending() {
    this.service.debatesTrending().subscribe(r => {
      this.debatesTrending = r;
    });
  }

  mostrarUsuariosTrending() {
    this.service.usuariosConMasSeguidores().subscribe(r => {
      this.usuariosTrending = r;
      this.dataSource.data = this.usuariosTrending;
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
