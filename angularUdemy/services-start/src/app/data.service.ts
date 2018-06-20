import {TableData} from './table-data.module';

export class DataService {
  private myData: TableData[] = [
    new TableData("hello1", 20, [4,2]),
    new TableData("hello2", 33, [2,2])
  ]


  getMyData() {
    return this.myData.slice();
  }

};
