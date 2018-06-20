import { BrowserModule } from '@angular/platform-browser';
import {NgModule, Provider} from '@angular/core';


import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { HeaderComponent } from './header/header.component';
import {AppRoutingModule} from './app-routing.module';
import { BlueberriesComponent } from './blueberries/blueberries.component';
import { BananasComponent } from './bananas/bananas.component';
import { GrapesComponent } from './grapes/grapes.component';
import { StrawberriesComponent } from './strawberries/strawberries.component';
import {ScrollToService} from './scrollTo.service';
import {aos, AosToken} from './aos';
import { InViewportModule, WindowRef } from '@thisissoon/angular-inviewport';
import { ScrollSpyModule } from '@thisissoon/angular-scrollspy';

export const getWindow = () => window;
export const providers: Provider[] = [
  { provide: WindowRef, useFactory: (getWindow) },
];


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    HeaderComponent,
    BlueberriesComponent,
    BananasComponent,
    GrapesComponent,
    StrawberriesComponent
  ],
  imports: [
    BrowserModule,
    InViewportModule.forRoot(providers),
    ScrollSpyModule.forRoot(),
    AppRoutingModule

  ],
  providers: [
    ScrollToService,
    {provide: AosToken, useValue: aos}
    ],
  bootstrap: [AppComponent]
})
export class AppModule { }
