window.App ||= {}

App.init = ->
	init_flash()
	init_boostrap_modal()
	

$(document).on "turbolinks:load", ->
  App.init()
	

# -------------------------------  JS functions  --------------------------------------------

# Init bootstrap modal for user log in
init_boostrap_modal = ->
	# Block links under modal
	$(".a").click (ev) ->
		if $(this).hasClass("blocked") == true
      		ev.preventDefault()
	# Show modal
	$('#connection_modal').on 'click', ->
		$('#devise_modal').fadeIn(1000)
		$(".modal-fade a").addClass("blocked")
		$('.modal-fade').fadeTo(1000, 0.2)
	# Hide modal
	$(window).on 'click', ->
		if !$(event.target).parents('.no-hide').length && !$(event.target).is(".no-hide")
			$('#devise_modal').fadeOut(1000)
			$(".modal-fade a").removeClass("blocked")
			$('.modal-fade').fadeTo(1000, 1)
	$('.register-link').on 'click', -> 
		$('#devise_modal').fadeOut(1000)

# Init flash
init_flash = ->
	$('#flash_msg').hide()
	#console.log 'Flash loaded'
	unless $('#flash_msg').length is 0
		show_flash()
	$('#flash_msg').change ->
		show_flash()
	$('.flash').click ->
		$(this).fadeOut 2000, ->
			$(this).empty()
	
# Show flash messages
show_flash = ->
	setTimeout ->
		$('#flash_msg').fadeIn 1000
	, 1000
	setTimeout ->
		$('#flash_msg')
			.fadeOut 2000, ->
				$(this).empty()
	, 6000
	console.log 'Flash fired'

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

