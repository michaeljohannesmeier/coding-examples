import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {Http} from '@angular/http';
import {ActivatedRoute, Router} from '@angular/router';
import {FahrradService} from '../fahrrad-service';

@Component({
  selector: 'app-addfahrrad',
  templateUrl: './addfahrrad.component.html',
  styleUrls: ['./addfahrrad.component.css']
})
export class AddfahrradComponent implements OnInit {

  form: FormGroup;
  checkInputFile: boolean = true;
  myImage: string;

  constructor(private http: Http,
              private router: Router,
              private route: ActivatedRoute,
              private fahrradService: FahrradService
  ) {}

  ngOnInit() {
    this.initForm();
  }

  onSubmit() {

    console.log(this.form.value);
    this.form.value.image = this.myImage;
    this.http.post('http://localhost:8082/postnewfahrrad', this.form.value).subscribe((response) => {
      console.log('fahrrad posted');
      this.fahrradService.getAllFahrrads();
      this.router.navigate(['../'], { relativeTo: this.route});
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
        this.checkInputFile = false;
        this.myImage =  reader.result.split(',')[1];
      };
    }
  }

  private initForm() {
    let name = '';
    let price = '';
    let descriptionShort = '';
    let descriptionLong = '';

    this.form = new FormGroup({
      'name': new FormControl(name, Validators.required),
      'price': new FormControl(price, [Validators.required,  Validators.pattern(/^[1-9]+[0-9]*$/)]),
      'descriptionShort': new FormControl(descriptionShort, Validators.required),
      'descriptionLong': new FormControl(descriptionLong, Validators.required),
      'image': new FormControl('')
    });
  }
}
