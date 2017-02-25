class Fabric < ApplicationRecord
	extend FriendlyId
  	friendly_id :serial, use: :slugged

  	after_save :affect_serial # Needs product ID
  	before_destroy :destroy_assets
	validates_uniqueness_of :serial, message: "This serial number is already used"
	validates_presence_of :kind, :title
	has_many :order_lines
	has_many :orders, through: :order_lines

	mount_uploader :image, FabricPictureUploader
	validate :image_size_validation

# ---------------- Scopes -------------------------------------------------------------------------

	scope :with_picture, -> { where.not image: nil }
	scope :active, -> { where activated: true }
	scope :random, -> { order('RAND()') }
	scope :with_kind, -> (kind) { where kind: kind }

# ---------------- Options & functions -----------------------------------------------------------------------------

	KINDS = ['silk', 'cotton', 'cotton-silk']
	PRICE_UNITS = ['€']

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
