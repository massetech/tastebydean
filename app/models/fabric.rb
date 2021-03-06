# == Schema Information
#
# Table name: fabrics
#
#  id               :integer          not null, primary key
#  serial           :string
#  kind             :string           default("fabric")
#  title            :string
#  fabric_family_id :integer
#  activated        :boolean          default("false")
#  origin           :string
#  content          :string
#  description      :text
#  stock_length     :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  slug             :string
#
# Indexes
#
#  index_fabrics_on_fabric_family_id  (fabric_family_id)
#

class Fabric < ApplicationRecord
	extend FriendlyId
  	friendly_id :serial, use: :slugged
  	belongs_to :fabric_family
	has_many :order_lines
	has_many :orders, through: :order_lines
	has_many :fabric_pictures, dependent: :destroy

	mount_uploader :image, FabricPictureUploader
	validate :image_size_validation
  	after_save :affect_serial # Needs product ID
  	before_destroy :destroy_assets
	validates_uniqueness_of :serial, message: "This serial number is already used"
	validates_presence_of :title, :fabric_family

# ---------------- Scopes -------------------------------------------------------------------------

	#scope :with_picture, -> { where.not image: nil }
	scope :on_site, -> { joins(:fabric_pictures)
		.where('fabric_pictures.activated = ?',true)
		.where('fabric_pictures.main = ?',true)
		.group("fabrics.id")
		.having("count(fabric_pictures.id) > ?",0)
	}
	scope :random, -> { order('RANDOM()') }
	scope :with_fabric_family, -> (family) { joins(:fabric_family)
		.where('fabric_families.title = ?', family)
	}

# ---------------- Options & functions -----------------------------------------------------------------------------

	def on_site?
		if self.activated == true && self.fabric_pictures.active.preview.count > 0 && self.fabric_pictures.active.view.count > 0
			true
		else
			false
		end
	end

	private 

	def affect_serial
		self.serial = "F" + Time.now.year.to_s.last(2) + "%.4d"%self.id
		self.update_column(:serial, serial)
		self.update_column(:slug, serial)
	end

	def image_size_validation
		errors[:image] << "should be less than 10MB" if image.size > 10.megabytes
	end

	def destroy_assets
		self.image.remove! if self.image
		self.save!
	end
end
