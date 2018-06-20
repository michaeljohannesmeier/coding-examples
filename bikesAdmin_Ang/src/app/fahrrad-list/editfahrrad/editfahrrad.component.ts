import {Component, Input, OnInit} from '@angular/core';
import {Fahrrad} from '../../fahrrad.model';
import {Http} from '@angular/http';
import {ActivatedRoute, Router} from '@angular/router';
import {FahrradService} from '../../fahrrad-service';

@Component({
  selector: 'app-editfahrrad',
  templateUrl: './editfahrrad.component.html',
  styleUrls: ['./editfahrrad.component.css']
})
export class EditfahrradComponent implements OnInit {
  @Input() fahrrad: Fahrrad;
  @Input() id: string;

  constructor(private http: Http,
              private router: Router,
              private route: ActivatedRoute,
              private fahrradService: FahrradService
  ) { }

  onDelete(){

    const myBody = {
      id: this.id
    };
    this.http.post('http://www.meiermichael.de/fahrraddelete', myBody).subscribe((response) => {
        console.log('fahrrad deleted');
        this.fahrradService.getAllFahrrads();
      }
    );

  }

  ngOnInit() {
  }

}
