// =====Price slider js=====
$(function() {
	$( "#slider-range" ).slider({
	  range: true,
	  min: 0,
	  max: 500,
	  values: [ 0, 500 ],
	  slide: function( event, ui ) {
		$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
	  }
	});
	$( "#amount" ).val( "$" + $( "#slider-range" ).slider( "values", 0 ) +
	  " - $" + $( "#slider-range" ).slider( "values", 1 ) );
});

// =====file upload js=====
function readURL(input) {
  if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
          $('#myFile')
              .attr('src', e.target.result)
      };

      $('.uploadedOuter').addClass('uploadedImg');

      reader.readAsDataURL(input.files[0]);
  }
};
// =====file upload js=====

function ShowMenu(){
  $('.mob-menu').addClass('ShowMenu');
  $('.overlay').css('display' , 'block');
}

function closeMenu(){
  $('.mob-menu').removeClass('ShowMenu');
  $('.overlay').css('display' , 'none')
}



if ($(window).width() < 769) {
  $('.BrowseInner').addClass('hideFilter');
} else {
  $('.BrowseInner').removeClass('hideFilter');
}


$(document).ready(function(){
    $('.search-toggler').click(function(){
        $('.head-search-outer').addClass('show-search');
    });
    $('.close-search').click(function(){
        $('.head-search-outer').removeClass('show-search');
    });

    $('.settingIcn').click(function(){
        $('.BrowseInner').toggleClass('hideFilter');
    });

    $('.t-btn').click(function(){
            $('.t-btn').removeClass('active');
            $(this).addClass('active');
    });

    $('.type-btn').click(function(){
        $('.type-btn').removeClass('active');
        $(this).addClass('active');
    });

    $('.showMoreBox').click(function(){
      $('.leftMainContainer').removeClass('lessBox');
      $('.leftMainContainer').addClass('moreBox');
    });

    $('.showLessBox').click(function(){
      $('.leftMainContainer').removeClass('moreBox');
      $('.leftMainContainer').addClass('lessBox');
    });

    $('#tab-content .tab-container').hide();
    $('#tab-content .tab-container:first').show();

    $('#tabNav .nav-item').click(function() {
        $('#tabNav .nav-item a').removeClass("active");
        $(this).find('a').addClass("active");
        $('#tab-content .tab-container').hide();

        var indexer = $(this).index(); //gets the current index of (this) which is #nav li
        $('#tab-content .tab-container:eq(' + indexer + ')').fadeIn(); //uses whatever index the link has to open the corresponding box 
    });

    $('.showFilter').click(function(){
      $('.rightSection').toggleClass('openFiltertop');
    });

});