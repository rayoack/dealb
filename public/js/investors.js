$(function() {

  /* Makes the entire row clickable */
  $('.investor__row').on('click', function() {
    const redirectPath = $(this).attr('id');

    console.log(window.location);

    window.location = redirectPath;
  });
});
