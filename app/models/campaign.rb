class Campaign < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :faqs, dependent: :destroy
  has_many :payments
  
  attr_accessible :name, :goal_type, :goal_dollars, :goal_orders,  :expiration_date, :ct_campaign_id, :media_type, 
                  :main_image, :main_image_delete, :video_embed_id, :video_placeholder, :video_placeholder_delete,
                  :contributor_reference, :progress_text, :primary_call_to_action_button, :primary_call_to_action_description,
                  :secondary_call_to_action_button, :secondary_call_to_action_description, :main_content, 
                  :checkout_sidebar_content, :confirmation_page_content, :confirmation_email_content,
                  :tweet_text, :facebook_title, :facebook_description,  :facebook_image, :facebook_image_delete,
                  :payment_type, :fixed_payment_amount, :min_payment_amount, :apply_processing_fee,
                  :collect_shipping_address, :stats_number_of_contributors, :stats_raised_amount, :stats_tilt_percent,
                  :stats_unique_contributors, :published_flag, :collect_shipping, :production_flag             
                  
  attr_accessor :main_image_delete, :video_placeholder_delete, :facebook_image_delete
  
  validates :name, :expiration_date, presence: true
  validates :min_payment_amount, numericality: { greater_than_or_equal_to: 1.0 }
  validates :fixed_payment_amount, numericality: { greater_than_or_equal_to: 1.0 }
  validate :expiration_date_cannot_be_in_the_past
  
  before_validation { main_image.clear if main_image_delete == '1' }
  before_validation { video_placeholder.clear if video_placeholder_delete == '1' }
  before_validation { facebook_image.clear if facebook_image_delete == '1' }

  has_attached_file :main_image, 
                    styles: { main: "512x385!", medium: "640x360!", small: "190x143!", thumb: "100x100#" }   
  
  has_attached_file :video_placeholder, 
                    styles: { main: "512x385!", medium: "640x360!", thumb: "100x100#" }  #The hash indicates cropping, use ! for forced scaling                   
                    
  has_attached_file :facebook_image, 
                    styles: { thumb: "100x100#" }

  before_save :set_min_amount
  
  def update_api_data(campaign)
    self.ct_campaign_id = campaign['id']
    self.stats_number_of_contributions = campaign['stats']['number_of_contributions']
    self.stats_raised_amount = campaign['stats']['raised_amount']/100.0
    self.stats_tilt_percent = campaign['stats']['tilt_percent']
    self.stats_unique_contributors = campaign['stats']['unique_contributors']
    self.is_tilted = campaign['is_tilted'].to_i == 0 ? false : true
    self.is_expired = campaign['is_expired'].to_i == 0 ? false : true
    self.is_paid = campaign['is_paid'].to_i == 0 ? false : true
  end
  
  def set_goal
  	if self.goal_type == 'orders'
  		self.goal_dollars = ((self.fixed_payment_amount * self.goal_orders)*100).round/100.0
  	end
  end
  
  def expired?
    self.expiration_date < Time.current
  end
  
  def orders
  	(self.stats_raised_amount / self.fixed_payment_amount).to_i
  end
  
  private
  
  def set_min_amount  
    if self.payment_type == "any"
      self.min_payment_amount = 1.0
    end
  end

  def expiration_date_cannot_be_in_the_past
    if self.expiration_date_changed? && !self.expiration_date.blank? && self.expiration_date < Time.current
      errors.add(:expiration_date, "can't be in the past")
    end
  end
  
end
