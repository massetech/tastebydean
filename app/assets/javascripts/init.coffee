window.App ||= {}

App.load = ->
	init_functions()

$ ->

$(document).on "turbolinks:load", ->
  	#App.load
	init_flash()
	init_fullpage()
	init_owl()
	init_devise_modal()
	init_slidebar()
	init_callbacks()		# Callbacks buttons valid for all pages
	#init_ezoom() 			# Elevate zoom plus on class .ezoom .active

#$('#footer').hide();

# -------------------------------  JS init functions  --------------------------------------------

# Init flash
init_flash = ->
	$('#flash_msg').hide()
	console.log 'Flash loaded'
	unless $('#flash_msg').length is 0
		show_flash()
	$('#flash_msg').change ->
		show_flash()
	$('.flash').click ->
		$(this).fadeOut 500, ->
			$(this).empty()

# Init fullpage
init_fullpage = ->
	if typeof $.fn.fullpage.destroy == 'function'
	    $.fn.fullpage.destroy('all')
	    console.log 'fullpage destroyed : fp init'
	if ($(".fp-all")[0]) || ($(".fp-mb")[0] && $(window).width() < 720) # Test if fp is on the page
		console.log 'fullpage loaded'
		$('#main').addClass('no-overflow'); # Correct the bug of multi scrolling
		$('#main-fp').fullpage
			fitToSectionDelay: 10000
			scrollOverflow: true
			afterLoad: (anchor, index) ->
				if $('.active').hasClass 'dyn-header' #anchor == 1
					$('#header').fadeIn('slow');
				if $('.active').hasClass 'dyn-footer' #anchor == 4
					$('#footer').fadeIn('slow');   	
			onLeave: (anchor, index) ->
				if $('.active').hasClass 'dyn-header'
					$('#header').fadeOut 'slow'
				if $('.active').hasClass 'dyn-footer'
					$('#footer').fadeOut 'slow'

# Init owl-carousel
init_owl = ->
	if $(".owl-carousel")[0] # Test if owl is on the page
		console.log 'owl loaded'
		$('.owl-carousel').owlCarousel
			onInitialized: set_ezoom_active
			onTranslated: reset_ezoom
			items: 1
			nav: true
			dots: true
			dotsEach: 1
			center: true
			loop: $('.owl-carousel img').length > 1 ? true : false
	# Buttons for images control
	$('#btn_prev').on 'click', ->
	    $('.owl-prev').trigger 'click'
	$('#btn_next').on 'click', ->
	    $('.owl-next').trigger 'click'

# Init devise modal
init_devise_modal = ->
	if $(window).width() > 719 # Load slidebar unless mobile
		console.log 'devise modal loaded'
		# Block links under modal
		$(".a").click (ev) ->
			if $(this).hasClass("blocked") == true
	      		ev.preventDefault()
		# Show modal
		$('.connect_modal').on 'click', ->
			remove_mb_menu()
			add_modal()
		# Hide modal
		$(window).on 'click', ->
			if !$(event.target).parents('.front').length
				remove_modal()
				#enable_fp()
		$('.register-link, .cross').on 'click', -> 
			remove_modal()
			enable_fp()

# Init Slidebar
init_slidebar = ->
	if $(window).width() < 720 # Load slidebar only on mobile
		console.log 'slidebar loaded'
		if $('.mb_main_menu').is(':visible') && typeof controller != "undefined" || $('.mb_filter_menu').is(':visible') && typeof controller != "undefined"
			controller.close('mb-main-menu')
			#console.log 'slidebar closed'	
		controller = new slidebars
		controller.init()
		$('.mb_main_menu').click (ev) ->
			#console.log 'slidebar opened'
			controller.open('mb-main-menu')
			ev.stopPropagation()
			ev.preventDefault()
		$('.mb_filter_menu').click (ev) ->
			#console.log 'slidebar opened'
			controller.open('mb-filter-menu')
			ev.stopPropagation()
			ev.preventDefault()
		$('.mb-hide').click (ev) ->
			if controller.isActiveSlidebar('mb-main-menu') || controller.isActiveSlidebar('mb-filter-menu')
				controller.close()
				#console.log 'slidebar closed'
				ev.stopPropagation()
				ev.preventDefault()
		$('.mb-quit').click (ev) ->
			controller.close()
			#console.log 'slidebar closed'

init_ezoom = ->
	if $(window).width() > 719 # Load slidebar unless mobile
		$(".ezoom.ez-active").ezPlus
			zoomWindowPosition: 'ez-container'
			zoomWindowHeight: 500
			zoomWindowWidth: 500
			#borderSize: 0
			zoomWindowFadeIn: 500
			zoomWindowFadeOut: 500
			lensFadeIn: 500
			lensFadeOut: 500
			scrollZoom: true
		console.log 'init_ezom fired'

init_callbacks = ->
	console.log 'callback loaded'
	$('#bsk_icon').hover (ev) -> 
		$('.message').toggleClass 'active'
	$("#zoom_btn").click (ev) ->
		toggle_btn_zoom()

toggle_btn_zoom = -> 
	$("#zoom_btn").toggleClass 'zoom-active'
	console.log 'zoom_btn toogled'								
	if $("#zoom_btn").hasClass('zoom-active')
		$('.zoom-icon-active').show()
		$('.zoom-icon-inactive').hide()
		init_ezoom()
	else
		$('.zoom-icon-inactive').show()
		$('.zoom-icon-active').hide()
		destroy_ezoom()
		console.log 'click fired'			

# -------------------------------  JS functions  --------------------------------------------
	
# Show flash messages
show_flash = ->
	setTimeout ->
		$('#flash_msg').fadeIn 1000
	, 1000
	setTimeout ->
		$('#flash_msg')
			.fadeOut 2000, ->
				$(this).empty()
	, 400000
	console.log 'Flash fired'

# Move nav buttons into carousel
change_nav = (event) ->
	$('#btn_prev').appendTo('.owl-dots')
	$('#btn_next').appendTo('.owl-dots')
	console.log 'nav changed'

# Apply active to the picture being owl2 active
set_ezoom_active = ->
	$('.ezoom').removeClass('ez-active')
	$('.ezoom').each ->
		if $(this).parents('.active').length
			$(this).addClass('ez-active')
		else
			$(this).removeClass('ez-active')
	console.log 'set_ez_active fired'

# Change ezoom target after owl changed
reset_ezoom = (event) ->
	if $("#zoom_btn").hasClass('zoom-active') # Switch button if zoom is ativated
		toggle_btn_zoom()
	set_ezoom_active()
	console.log 'reset_ezoom fired'

destroy_ezoom = ->
	if $('.ezoom.ez-active').data('ezPlus')
		$('.ezoom.ez-active').data('ezPlus').changeState('disable');
		console.log 'destroy_ezoom fired'

# Account handlers
account_handler = ->
	$('.create_account').on 'click', ->
		$('#account').fadeIn "slow"
		$('#create-account').show
		$('#connect-account').hide;
	$('.connect_account').on 'click', ->
		$('#account').fadeIn "slow"
		$('#connect-account').show
		$('#create-account').hide

add_modal = ->
	$('#devise_modal').fadeIn(500)
	$(".modal-fade a").addClass("blocked")
remove_modal = ->
	$('#devise_modal').fadeOut(500)
	$(".modal-fade a").removeClass("blocked")
