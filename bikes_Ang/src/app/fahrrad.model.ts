
declare const Buffer;

export class Fahrrad {
  public _id: string
  public name: string;
  public price: number;
  public descriptionShort: string;
  public descriptionLong: string;
  public image: {data: string, contentType: string};
  constructor(_id: string, name: string, price: number, descriptionShort: string, descriptionLong: string, image: {data: string, contentType: string} ) {
    this._id = _id;
    this.name = name;
    this.price = price;
    this.descriptionShort = descriptionShort;
    this.descriptionLong = descriptionLong;
    this.image = image;
  }
}
