import {Injectable, OnInit} from '@angular/core';

import {Recipe} from './recipe.model';
import {Ingredient} from '../shared/ingredient.model';
import {ShoppingListService} from '../shopping-list/shopping-list.service';
import {Subject} from 'rxjs/Subject';
import {Http} from '@angular/http';


@Injectable()
export class RecipeService {
  recipesChanged = new Subject<Recipe[]>();


  constructor(private slService: ShoppingListService,
              private http: Http) {}

  private recipes: Recipe[] = [];

  getRecipes() {
          this.http.get('http://www.meiermichael.de/restangulargetallrecipes').subscribe((response) => {
            this.recipes = response.json().recipes;
            this.recipesChanged.next(this.recipes.slice());
          });
  };

  addIngredientsToShoppingList(ingredients: Ingredient[]) {
    this.slService.addIngredients(ingredients);
  }

  getRecipe(id: string) {
    for (let i = 0; i < this.recipes.length; i++) {
      if (this.recipes[i]._id === id) {
        return this.recipes[i];
      }
    }
  }

  addRecipe(recipe: Recipe) {
    this.http.post('http://www.meiermichael.de/restangularaddnewrecipe', recipe).subscribe((response) => {
      this.recipes.push(response.json());
      this.recipesChanged.next(this.recipes.slice());
    });

  }
  updateRecipe(index: string, newRecipe: Recipe) {
    newRecipe._id = index;
    this.http.post('http://www.meiermichael.de/restangularupdaterecipe', newRecipe).subscribe((response) => {
      for (let i = 0; i < this.recipes.length; i++) {
        if (this.recipes[i]._id === index) {
          this.recipes[i] = response.json().recipe;
        }
        if (i === this.recipes.length - 1) {
          this.recipesChanged.next(this.recipes.slice());
        }
      }
    });
  }

  deleteRecipe(index: string) {
    const body = {index: index};
    for (let i = 0; i < this.recipes.length; i++) {
      if (this.recipes[i]._id === index) {
        this.recipes.splice(i, 1);
      }
    }
    this.http.post('http://www.meiermichael.de/restangulardeleterecipe', body).subscribe((response) => {
      this.recipesChanged.next(this.recipes.slice());
    });
  }

}
