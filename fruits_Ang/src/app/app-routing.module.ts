import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {HomeComponent} from './home/home.component';
import {BlueberriesComponent} from './blueberries/blueberries.component';
import {BananasComponent} from './bananas/bananas.component';
import {GrapesComponent} from './grapes/grapes.component';
import {StrawberriesComponent} from './strawberries/strawberries.component';

const appRoutes: Routes = [
  {path: '', redirectTo: '/home', pathMatch: 'full'},
  {path: 'home', component: HomeComponent},
  {path: 'blueberries', component: BlueberriesComponent},
  {path: 'grapes', component: GrapesComponent},
  {path: 'bananas', component: BananasComponent},
  {path: 'strawberries', component: StrawberriesComponent}

];

@NgModule({
  imports: [RouterModule.forRoot(appRoutes)],
  exports: [RouterModule]
})
export class AppRoutingModule {


}
