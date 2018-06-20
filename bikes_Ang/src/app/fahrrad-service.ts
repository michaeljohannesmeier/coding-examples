import {Fahrrad} from './fahrrad.model';
import {Injectable} from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {Http} from '@angular/http';

@Injectable()
export class FahrradService {
  fahrradsChanged = new Subject<Fahrrad[]>();

  constructor(private http: Http) {}

  private fahrrads: Fahrrad[];

  getAllFahrrads() {
    this.http.get('http://www.meiermichael.de/getallfahrrads').subscribe((response) => {
      console.log(response);
      this.fahrrads = response.json();
      this.fahrradsChanged.next(this.fahrrads.slice());
    });
  }
  getFahrrad(id) {
    for (let i = 0; i < this.fahrrads.length; i++) {
      if (this.fahrrads[i]._id === id) {
        return this.fahrrads[i];
      }
    }
  }

}
