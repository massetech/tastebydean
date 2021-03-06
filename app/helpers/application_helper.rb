module ApplicationHelper
	include ActionView::Helpers::TagHelper

# --------    Navigation -----------------------------------------

	def link_to_image(image_path, target_link,options={})
	  link_to(image_tag(image_path, :border => "0"), target_link, options)
	end

	def link_to_icon(name, width, height, target_link,options={})
	  link_to(image_tag('icons/' + name.to_s + '.png', width: width, height: height, class: 'icon'), target_link, options)
	end

	def find_logo_path
	  if params[:kind] == 'model'
	    @logo = 'collection'
	  elsif params[:kind] == 'material' || params[:kind] == 'accessory'
	    @logo = 'shop'
	  end
	  @logo
	end

	def select_title
		if params[:kind] == 'model'
			if params[:customer].nil?
				result = I18n.t('shop.filters.all_models')
			else
				result = I18n.t('shop.filters.' + params[:customer])
			end
		elsif params[:kind] == 'fabric'
			if params[:family].nil?
				result = I18n.t('shop.filters.all_fabrics')
			else
				result = I18n.t('shop.filters.' + params[:family])
			end
		end
	end

	#find the website area
	def define_area 
		if params[:kind] == 'model' || (!params[:id].nil? && params[:id][0] == 'M') 
			@area = 'model'
		elsif params[:kind] == 'creation' || (!params[:id].nil? && params[:id][0] == 'C') 
			@area = 'creation'
		elsif params[:kind] == 'accessory' || (!params[:id].nil? && params[:id][0] == 'A') 
			@area = 'accessory'
		elsif params[:kind] == 'fabric' || (!params[:id].nil? && params[:id][0] == 'F')
			@area = 'fabric'
		elsif request.original_url.include?('workshop')
			@area = 'workshop'
		elsif request.original_url.include?('cart')
			@area = 'workshop'
		elsif request.original_url.include?('users')	
			@area = 'users'
		end
		@area
	end

	# Find the header link to highlight
	def select_logo_title
		define_area
		if @area == 'model'
			logo_title = t('layouts.main_filters.collection')
		elsif @area == 'creation'
			logo_title = t('layouts.main_filters.creation')
		elsif @area == 'accessory' || @area == 'fabric' || @area == 'workshop'
			logo_title = t('layouts.main_filters.shop')
		end
	end

	def selected_header_link(option, url)
		define_area
		if @area == 'model'
			if option == 'collection'
				result = link_to I18n.t('layouts.main_filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('layouts.main_filters.' + option), url
			end
		elsif @area == 'creation'
			if option == 'creation'
				result = link_to I18n.t('layouts.main_filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('layouts.main_filters.' + option), url
			end
		elsif @area == 'accessory' || @area == 'fabric' || @area == 'workshop'
			if option == 'shop'
				result = link_to I18n.t('layouts.main_filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('layouts.main_filters.' + option), url
			end
		end
	end

	def selected_link(option, url)		
		if params[:kind] == 'model'
			if params[:customer].nil? && option.include?('all')
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			elsif params[:customer] == option
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('shop.filters.' + option), url
			end
		elsif params[:kind] == 'accessory'
			if option == 'accessories'
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('shop.filters.' + option), url
			end
		elsif params[:kind] == 'fabric'
			if params[:family].nil? && option.include?('all')
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			elsif params[:family] == option
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('shop.filters.' + option), url
			end
		elsif request.original_url.include?('workshop')
			if option == 'workshop'
				result = link_to I18n.t('shop.filters.' + option), url, class: 'selected'
			else
				result = link_to I18n.t('shop.filters.' + option), url
			end
		end
		result
	end

# --------    Flash messages display -----------------------------------------

	def flash_message (type, msg)
		flash[type] ||= []
		flash[type] << msg
	end

	def render_flash
		flash_array = []
  		flash.each do |type, messages|
  			if messages.is_a?(String)
  				flash_array << render(partial: 'layouts/flash', 
  				locals: { type: type, message: messages })
  			else
	  			messages.each do |msg|
	  				flash_array << render(partial: 'layouts/flash', 
	  				locals: { type: type, message: msg }) unless msg.blank?
  				end
  			end
  		end
		#flash.clear
  		flash_array.join('').html_safe
	end

# --------    Modal devise -----------------------------------------
	
	def resource_name
		:user
	end

	def resource
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end


# --------    Languages -----------------------------------------
	
	def alternate_locales
	  # Remove current locale from list
	  #aval_locales_but_current = I18n.available_locales - [locale]
	end

	def flag(language, width, height)
		#image_tag('flags/' + language.to_s + '.jpg', width: width, height: height)
	end
	
end
