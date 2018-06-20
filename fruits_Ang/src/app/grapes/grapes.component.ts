import {Component, OnInit} from '@angular/core';
import {ScrollToService} from '../scrollTo.service';
import {Image} from '../image.model';

@Component({
  selector: 'app-grapes',
  templateUrl: './grapes.component.html',
  styleUrls: ['./grapes.component.css']
})
export class GrapesComponent implements OnInit {
  galleryOpen: boolean = false;
  myDisplay: string = 'none';
  images: Image[];

  constructor(private scrollService: ScrollToService) { }

  ngOnInit() {
    this.scrollService.setScroll(0, 0);
    this.images = [
      new Image(
         'assets/grapes2.jpg',
         'Graaapes',
        'Grapes in green and red in a bowl'
      ),
      new Image(
        'assets/grapes3.jpg',
        'Graaapes',
        'Grapes in red, green and black'
      ),
      new Image(
        'assets/grapes4.jpg',
        'Graaapes',
        'Two purple grapes bunches on a tree'
      ),
      new Image(
        'assets/grapes5.jpg',
        'Graaapes',
        'A lot of grapes bunches on a tree'
      ),
      new Image(
        'assets/grapes6.jpg',
        'Graaapes',
        'Grapes in red'
      ),
      new Image(
        'assets/grapes7.jpg',
        'Graaapes',
        'Grapes in red on a tree'
      ),
      new Image(
        'assets/grapes8.jpg',
        'Graaapes',
        'Grapes in green'
      ),
      new Image(
        'assets/grapes9.jpg',
        'Graaapes',
        'Grapes in purple'
      ),
      new Image(
        'assets/grapes10.jpg',
        'Graaapes',
        'Grapes in red on a tree'
      ),
      new Image(
        'assets/grapes11.jpg',
        'Graaapes',
        'Grapes in purple and green'
      )
    ]
  }

  openCloseGallery() {
    if (this.galleryOpen) {
      this.galleryOpen = false;
      this.myDisplay = 'none';
        window.scroll(0, 100);
    } else {
      this.galleryOpen = true;
      this.myDisplay = 'block';
      var resolveAfter1Seconds = function () {
        return new Promise(resolve => {
          setTimeout(() => {
            resolve('resolved');
          }, 10);
        });
      };
      var asyncCall = async function () {
        await resolveAfter1Seconds();
        window.scroll(0, 700);
      }
      asyncCall();
    }
  }

  openModal(image: Image) {
    const modalImg = document.getElementById('myModal');
    const imgModal = document.getElementById('imgModal');
    const captionText = document.getElementById('caption');
    console.log(modalImg.style.display);
    modalImg.style.display = 'block';
    imgModal.setAttribute('src', image.src);
    captionText.innerHTML = image.desc;
  }
  onClose() {
    const modalImg = document.getElementById('myModal');
    modalImg.style.display = 'none';
  }


}
