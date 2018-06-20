import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { AddfahrradComponent } from './addfahrrad/addfahrrad.component';
import { EditfahrradComponent } from './fahrrad-list/editfahrrad/editfahrrad.component';
import {AppRoutingModule} from './app-routing.module';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {HttpModule} from '@angular/http';
import {UnsafePipe} from './unsafe.pipe';
import { FahrradListComponent } from './fahrrad-list/fahrrad-list.component';
import {FahrradService} from './fahrrad-service';
import { FahrradDetailComponent } from './fahrrad-detail/fahrrad-detail.component';




@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    AddfahrradComponent,
    EditfahrradComponent,
    UnsafePipe,
    FahrradListComponent,
    FahrradDetailComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpModule,
    ReactiveFormsModule
  ],
  providers: [FahrradService ],
  bootstrap: [AppComponent]
})
export class AppModule { }
