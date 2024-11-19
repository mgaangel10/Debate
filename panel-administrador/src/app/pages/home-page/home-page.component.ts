import { Component } from '@angular/core';
import { AdminServiceService } from '../../service/admin-service.service';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrl: './home-page.component.css'
})
export class HomePageComponent {
  constructor(private service:AdminServiceService){}

}
