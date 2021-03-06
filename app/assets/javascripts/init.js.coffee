window.App ||= {}

App.load = ->
	init_functions()

$(document).on "turbolinks:load", ->
	init_country_select()
	init_flash()
	init_layouts()
	init_fullpage()
	init_owl()
	init_slidebar()	
	init_callbacks()		# Callbacks buttons valid for all pages
	init_scroll() 			# Hide header on scroll
	init_ezoom()
	init_nice_select()
	init_welcome()
	init_shop()
	init_cart()

# -------------------------------  JS init functions  --------------------------------------------

# Init the header and footer specific rules
init_layouts = ->
	if $(".hd-trsp")[0] # Test if header needs to be pushed for full page image
		$('#header').addClass('covered')
	
	# Test if header needs to be pushed for full page image for tb
	if $(".hd-tb-trsp")[0]
		if $(window).width() > 720
			$('#header').addClass('covered')
		else
			$('#header').addClass('hide')

	if $(".ft-no")[0]
		$('#footer').addClass('hide')

init_country_select = ->
	switch locale
		when 'en' then loc = 'gb'
		when 'bi' then loc = 'mm'
		else loc = 'fr'
	console.log loc
	$("#country_id").countrySelect
		onlyCountries: ['fr', 'gb', 'mm']
		preferredCountries: []
		defaultCountry: loc
	$(".country_select_container").hover (ev) ->
		#$('.country-list').removeClass('hide')
	$(".country_select_container").mouseleave (ev) ->
		#$('.country-list').addClass('hide')
	$("#country_id").change ->
		countryCode = $(".country_select_container").find(".selected-flag .flag").attr("class").split(" ")[1]
		switch countryCode
			when 'gb' then $("#switch_en")[0].click()
			when 'fr' then $("#switch_fr")[0].click()
			when 'mm' then $("#switch_bi")[0].click()
		
init_nice_select = ->
	$('select').niceSelect()		

# Init scroll hiding headers
init_scroll = ->
	didScroll = false
	@lastScrollTop = 0
	@delta = 5
	@navbarHeight = 40
	$('#main').scroll (event) ->
		didScroll = true
	setInterval ->
		if didScroll
			hasScrolled()
			didScroll = false
	, 250
	#console.log 'scroll loaded'

# Init flash
init_flash = ->
	$('#flash_msg').hide()
	#console.log 'Flash loaded'
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
	    $.fn.fullpage.destroy('all')  # Avoid loading many times FP
	    console.log 'fullpage destroyed : fp init'
	if ($(".fp-all")[0]) || ($(".fp-mb")[0] && $(window).width() < 720) # Test if fp is on the page
		console.log 'fullpage loaded'
		#$('#main').addClass('no-overflow') # Correct the bug of multi scrolling
		$('#fullpage').fullpage
			fitToSectionDelay: 10000
			scrollOverflow: false
			autoScrolling: true
			paddingTop: '1em'
			paddingBottom: '1em'
			afterLoad: (anchor, index) ->
				if $('.active').hasClass 'dyn-header'
					$('#header').removeClass('nav-off').addClass('nav-on')
				if $('.active').hasClass 'dyn-footer'
					$('#footer').removeClass('nav-off').addClass('nav-on')  	
			onLeave: (anchor, index) ->
				if $('#header').hasClass 'nav-on'
					$('#header').removeClass('nav-on').addClass('nav-off')
				if $('#footer').hasClass 'nav-on'
					$('#footer').removeClass('nav-on').addClass('nav-off')

# Init owl-carousel
init_owl = ->
	if $(".owl-carousel")[0] # Test if owl is on the page
		console.log 'owl loaded'
		$('.owl-carousel').owlCarousel
			onInitialized: set_ezoom_active
			onTranslated: set_ezoom_active #Before was reset_ezoom
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
			console.log 'slidebar closed'

init_ezoom = ->
	if $(window).width() > 1023 # Load slidebar unless mobile
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
	#console.log 'callback loaded'
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
	, 5000
	console.log 'Flash fired'

# Move nav buttons into carousel
change_nav = (event) ->
	$('#btn_prev').appendTo('.owl-dots')
	$('#btn_next').appendTo('.owl-dots')
	console.log 'nav changed'

# Apply active to the picture being owl2 active
set_ezoom_active = ->
	destroy_ezoom()
	$('.ezoom').removeClass('ez-active')
	$('.ezoom').each ->
		if $(this).parents('.active').length
			$(this).addClass('ez-active')
		else
			$(this).removeClass('ez-active')
	init_ezoom()
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

# Show/Hide on scroll
hasScrolled = ->
	if ($(".fp-all")[0]) || ($(".fp-mb")[0]) # Avoid function if FP is on the page
		return
	#console.log 'hasScroll fired'
	st = $('#main').scrollTop()
	if Math.abs(lastScrollTop - st) <= delta		# Make sure they scroll more than delta
		return
	if st > lastScrollTop && st > @navbarHeight		# Scroll down
		$('#header').removeClass('nav-on').addClass('nav-off')
	else
		if st < lastScrollTop						# Scroll up
			$('#header').removeClass('nav-off').addClass('nav-on')
			$('#footer').removeClass('nav-on').addClass('nav-off')
	#if st > Math.abs($('#main').height() - 100)		# On bottom
	if st + $('#main').innerHeight() >= $('#main')[0].scrollHeight
		$('#footer').removeClass('nav-off').addClass('nav-on')
		#alert('end reached')
		#console.log 'top bottom'
	@lastScrollTop = st