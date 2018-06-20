import {Ingredient} from '../shared/ingredient.model';

export class Recipe {
  public _id: String;
  public name: string;
  public description: string;
  public imagePath: string;
  public ingredients: Ingredient[];

  constructor(_id: string, name: string, desc: string, imagePath: string, ingredients: Ingredient[]) {
    this._id = _id;
    this.name = name;
    this.description = desc;
    this.imagePath = imagePath;
    this.ingredients = ingredients;
  }
}
