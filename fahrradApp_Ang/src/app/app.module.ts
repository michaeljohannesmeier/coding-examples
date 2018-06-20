import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { HeaderComponent } from './header/header.component';
import { FahrradListComponent } from './fahrrad-list/fahrrad-list.component';
import { FahrradDetailComponent } from './fahrrad-detail/fahrrad-detail.component';
import { ContactComponent } from './contact/contact.component';
import { AppRoutingModule } from './app-routing.module';
import {FahrradService} from './fahrrad-service';
import { FahrradItemComponent } from './fahrrad-item/fahrrad-item.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {HttpModule} from '@angular/http';
import {UnsafePipe} from './unsafe.pipe';



@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FahrradListComponent,
    FahrradDetailComponent,
    ContactComponent,
    FahrradItemComponent,
    UnsafePipe

  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpModule
  ],
  providers: [FahrradService],
  bootstrap: [AppComponent]
})
export class AppModule { }
