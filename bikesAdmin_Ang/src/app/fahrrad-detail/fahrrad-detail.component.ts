import {Component, Input, OnInit} from '@angular/core';
import {FahrradService} from '../fahrrad-service';
import {ActivatedRoute, Params, Router} from '@angular/router';
import {Fahrrad} from '../fahrrad.model';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Http} from '@angular/http';

@Component({
  selector: 'app-fahrrad-detail',
  templateUrl: './fahrrad-detail.component.html',
  styleUrls: ['./fahrrad-detail.component.css']
})
export class FahrradDetailComponent implements OnInit {
  fahrrad: Fahrrad;
  id: string;
  form: FormGroup;
  myImage: string;

  constructor(private fahrradService: FahrradService,
              private router: Router,
              private route: ActivatedRoute,
              private http: Http) { }

  ngOnInit() {
    this.route.params.subscribe(
      (params: Params) => {
        this.id = params['id'];
        this.fahrrad = this.fahrradService.getFahrrad(this.id);
        this.myImage = this.fahrradService.getFahrrad(this.id).image.data;
      }
    );
    this.initForm();
  }

  onSubmit() {
    console.log(this.form.value);
    this.form.value.image = this.myImage;
    this.form.value._id = this.id;
    this.http.post('http://www.meiermichael.de/editfahrrad', this.form.value).subscribe((response) => {
        console.log('fahrrad updated');
        this.fahrradService.getAllFahrrads();
        this.router.navigate(['../../'], { relativeTo: this.route});
      }
    );
  }

  onFileChange(event) {
    let reader = new FileReader();
    if(event.target.files && event.target.files.length > 0) {
      let file = event.target.files[0];
      reader.readAsDataURL(file);
      reader.onload = () => {
        console.log(reader.result.split(',')[1]);
        this.myImage =  reader.result.split(',')[1];
      };
    }
  }

  private initForm() {
    let name = this.fahrrad.name;
    let price = this.fahrrad.price;
    let descriptionShort = this.fahrrad.descriptionShort;
    let descriptionLong = this.fahrrad.descriptionLong;

    this.form = new FormGroup({
      'name': new FormControl(name, Validators.required),
      'price': new FormControl(price, [Validators.required,  Validators.pattern(/^[1-9]+[0-9]*$/)]),
      'descriptionShort': new FormControl(descriptionShort, Validators.required),
      'descriptionLong': new FormControl(descriptionLong, Validators.required),
      'image': new FormControl('')
    });
  }

}
