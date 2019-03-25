var swiperUpdates = new Swiper('.swiper-updates', {
  pagination: '.swiper-pagination',
  nextButton: '.arrows-controls .arrow-right',
  prevButton: '.arrows-controls .arrow-left',
  slidesPerView: 3,
  spaceBetween: 30,
  breakpoints: {
    991: {
      slidesPerView: 2,
      spaceBetween: 20
    },
    769: {
      slidesPerView: 1,
      spaceBetween: 15
    }
  }
});
