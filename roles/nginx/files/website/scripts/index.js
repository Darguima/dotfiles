"use strict";

var countDownDate = new Date('Jun 04, 2004 15:05:00');
var daysOnCountdownMonth = new Date(countDownDate.getFullYear(), countDownDate.getMonth() + 1, 0).getDate();
var imagesAmount = 0;

function main() {
  preloadImages(); // image cache
  // toggleFlippedClass()

  timer();
}

main();

function preloadImages() {
  var img = new Image();
  nextImage();
  console.log('Image Cache Ready');

  function nextImage() {
    var imageIndex = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 1;
    if (imageIndex > imagesAmount) return;
    img.src = "assets/images/image".concat(imageIndex, ".jpg");

    img.onload = function () {
      nextImage(imageIndex + 1);
    };
  }
}

function toggleFlippedClass() {
  var card = document.querySelector('#contentContainer');
  var image = document.querySelector('#contentContainer .back .image');
  var bgImage = document.querySelector('#contentContainer .back .bg-image');
  var animationDelay = Number(getComputedStyle(document.documentElement).getPropertyValue('--transform-animation-delay').replace('s', ''));
  toggleBackFaceImage(image, bgImage);
  card === null || card === void 0 ? void 0 : card.addEventListener('click', function () {
    card.classList.toggle('flipped');

    if (!card.classList.contains('flipped')) {
      setTimeout(function () {
        return toggleBackFaceImage(image, bgImage);
      }, animationDelay * 1000);
    }
  });
}

function toggleBackFaceImage(image, bgImage) {
  var previousImageNumber = Number(((image.src.match(/[\w-]+\.jpg/g) || ['0'])[0].match(/\d+/) || ['0'])[0]);
  var randomImageNumber;

  do {
    randomImageNumber = Math.floor(Math.random() * imagesAmount) + 1;
  } while (previousImageNumber === randomImageNumber);

  image.src = "assets/images/image".concat(randomImageNumber, ".jpg");
  bgImage.style.backgroundImage = "url(\"assets/images/image".concat(randomImageNumber, ".jpg\")");
}

function timer() {
  var timerContainer = document.getElementById('timerContainer');
  var counters = document.querySelectorAll('.counterText');
  setInterval(function () {
    var now = new Date();
    if (now.getTime() - countDownDate.getTime() < 0) console.log('invalid date');
    var seconds = now.getSeconds() - countDownDate.getSeconds();
    var minutes = now.getMinutes() - countDownDate.getMinutes();
    var hours = now.getHours() - countDownDate.getHours();
    var days = now.getDate() - countDownDate.getDate();
    var months = now.getMonth() - countDownDate.getMonth();
    var years = now.getFullYear() - countDownDate.getFullYear();

    if (seconds < 0) {
      seconds += 60;
      minutes -= 1;
    }

    if (minutes < 0) {
      minutes += 60;
      hours -= 1;
    }

    if (hours < 0) {
      hours += 24;
      days -= 1;
    }

    if (days < 0) {
      days += daysOnCountdownMonth;
      months -= 1;
    }

    if (months < 0) {
      months += 12;
      years -= 1;
    }

    timerContainer.style.maxHeight = '100vh';
    counters[0].innerText = "".concat(years, " years");
    counters[1].innerText = "".concat(months, " months");
    counters[2].innerText = "".concat(days, " days");
    counters[3].innerText = "".concat(hours, " hours");
    counters[4].innerText = "".concat(minutes, " minutes");
    counters[5].innerText = "".concat(seconds, " seconds");
  }, 1000);
}