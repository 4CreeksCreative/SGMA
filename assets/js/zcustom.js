$(document).on('scroll', function(){
	if($(document).scrollTop() > 300 && !$('header').hasClass('sticky')){
		$('header').addClass('sticky');
	}
	else if ($(document).scrollTop() < 300 && $('header').hasClass('sticky')){
		$('header').removeClass('sticky');
	}
})
$(window).on('resize',function(){
	if($('body').hasClass('custom-toggled-class')){
		$('#menu-overlay-toggle,#menu1,body').toggleClass('custom-toggled-class')
	}
})
// $(document).on('click','.organization',function(){
// 	$(this).find('.contact-info').slideToggle(300)
// 	setTimeout(mr.masonry.updateLayout, 300)
// })
$(document).on('mousedown','a',function(e){
	if ($(this).attr('href') != undefined && $(this).attr('href') != '' && /(#\w+$)/.test($(this).attr('href'))){
		var samePage = /(\w)+(?=#\w+$)/.exec($(this).attr('href')) != null ? /(\w)+(?=#\w+$)/.exec($(this).attr('href')) : [pageClass]
		samePage = samePage[0]
		if (samePage === pageClass){
			e.preventDefault();
			var element = /(#\w+$)/.exec($(this).attr('href'))
			element = element[0]
			$('html,body').stop().animate({
				scrollTop:$(element).offset().top - 100,
				easing: 'swing',
			},500)
			if ($(window).width() <= 992){
				$('#menu-overlay-toggle,#menu1,body').toggleClass('custom-toggled-class')
			}
		}
	}
})
$(document).ready(function(){
	if (window.location.hash){
		$('html, body').stop().animate({
			scrollTop: $(window.location.hash).offset().top -100,
			easing: 'swing'
		},500)
	}
})
function infoBox(obj){
	var popup = new mapboxgl.Popup()
		.setHTML('<h4>'+obj.properties.title+'</h4><a class="btn btn-blue" href="'+obj.properties.url+'"><span class="btn__text">Contact GSA</span></a>')
		.setLngLat(obj.geometry.coordinates)
		.addTo(map);
}
$(document).on('click', '.location', function (e) {
	e.preventDefault();
	var string = new RegExp('(' + $(this).find('.loc').text() + ')', 'ig'),
	matchedCoordinates = [], props = {}
	$.each(geojson.features, function (i, val) {
		if (!val.properties.title.search(string)) {
			$('.mapboxgl-popup').hide();
			map.flyTo({
				center:val.geometry.coordinates,
				zoom:14
			})
			infoBox(val)
		}
	})
})
